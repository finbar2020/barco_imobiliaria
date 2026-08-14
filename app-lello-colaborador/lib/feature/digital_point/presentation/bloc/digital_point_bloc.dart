import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_life_validation_config_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_capture_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_life_validation_config.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_register_failure.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/register_point/register_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/request_digital_point/request_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/save_point/save_point.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_event.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_state.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:colaborador/lello_app.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:shared_features/shared_features.dart';

class DigitalPointBloc extends Bloc<DigitalPointEvent, DigitalPointState> {
  final RequestDigitalUsecase requestDigitalUsecase;
  final RegisterPointUsecase registerPointUsecase;
  final GetImageFromCameraViewPickerUsecase getImageFromCameraViewPickerUsecase;
  final SavePointUsecase savePointUsecase;
  final SessionBloc sessionBloc;
  late SharedPreferences preferences;

  final AppConnectivity appConnectivity;

  DigitalPointBloc({
    required this.appConnectivity,
    required this.requestDigitalUsecase,
    required this.registerPointUsecase,
    required this.getImageFromCameraViewPickerUsecase,
    required this.savePointUsecase,
    required this.sessionBloc,
  }) : super(const FaceInitialPictureState()) {
    on<StatCameraCaptureEvent>(_mapStatCameraCapture);
    on<SendFaceEvent>(_mapSendFile);
    on<SavePointEvent>(_mapSavePoint);
    on<CancelPointEvent>(_mapCancelPoint);
    if (sessionBloc.state is SessionLoadedState) {
      add(
        StatCameraCaptureEvent(
          statusEnum: (sessionBloc.state as SessionLoadedState)
              .session
              .condominium
              .digitalTimesheetStatus,
        ),
      );
    }
  }

  final InactivityCubit inactivityCubit =
      ApplicationContainer.instance().resolve<InactivityCubit>();

  void sendFile({
    required CameraViewPickerResult file,
    required DigitalTimesheetStatusEnum statusEnum,
    required bool mustSave,
    Map<String, DateTime?>? mapRegisteredPointDate,
    String? condoRef,
    EmployeeInfo? employee,
  }) {
    appConnectivity.checkConnectivity().then((value) {
      if (value) {
        add(
          SendFaceEvent(
            image: file,
            statusEnum: statusEnum,
            mustSave: mustSave,
            mapRegisteredPointDate: mapRegisteredPointDate,
          ),
        );
      } else if (statusEnum == DigitalTimesheetStatusEnum.approved) {
        add(SavePointEvent(
          image: file,
          condoRef: condoRef,
          employee: employee,
        ));
      } else {
        add(const CancelPointEvent());
      }
    });
  }

  Future<void> _mapStatCameraCapture(
    StatCameraCaptureEvent event,
    Emitter<DigitalPointState> emit,
  ) async {
    final Trace myTrace =
        FirebasePerformance.instance.newTrace("capture_digitalpoint");
    await myTrace.start();
    unawaited(_getHighPosition());
    CameraViewPickerResult? image;
    preferences = await SharedPreferences.getInstance();
    var cameras = await availableCameras();
    DateTime? registeredPointDate;

    Map<String, DateTime?>? parsedMap;
    if (preferences.getString(SharedPreferencesKeys.registeredPointDate) !=
        null) {
      Map<String, String?>? map = Map<String, String?>.from(
        json.decode(
          preferences.getString(SharedPreferencesKeys.registeredPointDate)!,
        ),
      );
      parsedMap = map.map(
        (key, value) {
          return MapEntry(key, DateTimeUtils.fromFormattedString(value));
        },
      );
      registeredPointDate = parsedMap[sessionBloc.getSession?.me.id];
    }

    bool mustValidateLife = false;

    if (registeredPointDate != null) {
      Duration difference = DateTime.now().difference(registeredPointDate);
      if (difference.inDays >= 15) {
        mustValidateLife = true;
      }
    } else {
      mustValidateLife = true;
    }

    var faceValidationSettings = _getFaceValidationSettings(
      sessionBloc: sessionBloc,
    );

    final condoRef = int.tryParse(event.condoRef ?? '') ?? 0;

    mustValidateLife = false;
    int qteActionsLifeValidation =
        faceValidationSettings.globalConfig.qteActionsLifeValidation;
    bool isRandomActionsLifeValidation =
        faceValidationSettings.globalConfig.isRandomActionsLifeValidation;
    List<LifeValidationTypeEnum> actionsLifeValidation =
        faceValidationSettings.globalConfig.actionsLifeValidation;

    if (faceValidationSettings.enabled) {
      mustValidateLife =
          faceValidationSettings.globalConfig.requireLivenessCheck;

      final condosFiltered = faceValidationSettings.condominiums
          .where((c) => c.referencia == condoRef);
      final condo = condosFiltered.isEmpty ? null : condosFiltered.first;

      if (condo != null) {
        mustValidateLife = condo.requireLivenessCheck;

        if (condo.qteActionsLifeValidation != null) {
          qteActionsLifeValidation = condo.qteActionsLifeValidation!;
        }
        if (condo.isRandomActionsLifeValidation != null) {
          isRandomActionsLifeValidation = condo.isRandomActionsLifeValidation!;
        }
        if (condo.actionsLifeValidation != null) {
          actionsLifeValidation = condo.actionsLifeValidation!;
        }
      }
    } else {
      mustValidateLife = false;
    }

    inactivityCubit.cancel();

    if (event.statusEnum.isApproved && !mustValidateLife) {
      image = await handleUseCase(
        getImageFromCameraViewPickerUsecase,
        ParamsGetImageFromCameraViewPickerUsecase(
          captureEnum: TypeCaptureEnum.automatic,
          context: navigatorKey.currentState!.context,
          cameras: cameras,
          isColaboradorApp: true,
        ),
      ).onError((error, stackTrace) => CameraViewPickerResult(
          file: null, captureEnum: TypeCaptureEnum.automatic));
    } else {
      image = await handleUseCase(
        getImageFromCameraViewPickerUsecase,
        ParamsGetImageFromCameraViewPickerUsecase(
          context: navigatorKey.currentState!.context,
          cameras: cameras,
          captureEnum: mustValidateLife
              ? TypeCaptureEnum.lifeValidation
              : TypeCaptureEnum.automatic,
          isRandomActionsLifeValidation: isRandomActionsLifeValidation,
          qteActionsLifeValidation: qteActionsLifeValidation,
          actionsLifeValidation: actionsLifeValidation,
          isColaboradorApp: true,
        ),
      );
    }
    inactivityCubit.start();

    if (image != null && image.file != null) {
      if (image.captureEnum.isManual && !Platform.isIOS) {
        List<Face> faces = await getFaces(image);
        if (faces.length != 1) {
          myTrace.putAttribute("succes", "false");
          myTrace.putAttribute("status", "noFace");
          await myTrace.stop();
          emit(const FaceRequestNoFacePictureState());
          return;
        }
      }
      sendFile(
        file: image,
        statusEnum: event.statusEnum,
        mapRegisteredPointDate: parsedMap,
        mustSave: mustValidateLife,
        condoRef: event.condoRef,
        employee: event.employee,
      );
    } else if (image != null && image.file == null) {
      myTrace.putAttribute("succes", "false");
      myTrace.putAttribute("status", "error");
      emit(const FaceRequestErrorPictureState());
    } else {
      myTrace.putAttribute("succes", "false");
      myTrace.putAttribute("status", "canceled");
      emit(const FaceRequestCanceledPictureState());
    }
    await myTrace.stop();
  }

  static DigitalPointLifeValidationConfig _getFaceValidationSettings(
      {required SessionBloc sessionBloc}) {
    try {
      FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;
      if (remoteConfig != null) {
        var rangeMaxPermitted = jsonDecode(remoteConfig
            .getString(CustomFirebaseRemoteConfig.lifeValidationConfig));

        return DigitalPointLifeValidationConfigModel.fromJson(rangeMaxPermitted)
            .toEntity();
      }
      return DigitalPointLifeValidationConfig.empty();
    } catch (err) {
      return DigitalPointLifeValidationConfig.empty();
    }
  }

  Future<List<Face>> getFaces(CameraViewPickerResult image) async {
    final inputImage = InputImage.fromFilePath(image.file!.path);
    final faces = await FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        minFaceSize: 0.5,
      ),
    ).processImage(inputImage).timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        return List.empty();
      },
    );
    return faces;
  }

  Future<void> _mapSendFile(
    SendFaceEvent event,
    Emitter<DigitalPointState> emit,
  ) async {
    bool isRegister = event.statusEnum == DigitalTimesheetStatusEnum.approved;
    if (isRegister) {
      await _registerDigitalPoint(event, emit);
    } else {
      await _requestDigitalPoint(event, emit);
    }
  }

  Future<void> _mapCancelPoint(
    CancelPointEvent event,
    Emitter<DigitalPointState> emit,
  ) async {
    emit(const FaceRequestCanceledPictureState());
  }

  Future<void> _requestDigitalPoint(
    SendFaceEvent event,
    Emitter<DigitalPointState> emit,
  ) async {
    try {
      emit(const FaceLoadingPictureState());

      String condoId = sessionBloc.getSession?.condominium.id ?? "";

      Position position = await _getUserOrCondoPosition();

      final result = await requestDigitalUsecase.call(
        RequestDigitalParam(
          condoId: condoId,
          file: File(event.image.file!.path),
          position: position,
        ),
      );

      DigitalPointState response = result.fold((l) {
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.homeRegistrarPontoDigitalFalhaEnvio(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        return const FaceRequestFailedPictureState();
      }, (s3) {
        EmployeeAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.homeEnvioFolhaPontoSucesso(),
          referenceValue:
              sessionBloc.getSession?.condominium.reference.toString() ?? "",
        );
        return const FaceRequestLoadedPictureState();
      });

      emit(response);
    } on TimeoutException catch (e) {
      emit(LocationTimeoutFailedPictureState(e));
    } catch (e) {
      emit(FaceRequestFailedPictureState(e as Exception));
    }
  }

  Future<void> _registerDigitalPoint(
    SendFaceEvent event,
    Emitter<DigitalPointState> emit,
  ) async {
    try {
      emit(const FaceLoadingPictureState());

      final Trace myTrace =
          FirebasePerformance.instance.newTrace("send_digitalpoint");
      await myTrace.start();
      var session = sessionBloc.getSession;
      String condoId = sessionBloc.getSession?.condominium.id ?? "";
      String meId = sessionBloc.getSession?.me.id ?? "";
      DateTime date = DateTime.now();

      Position position = await _getUserOrCondoPosition();

      File? file = await convertFile(event.image.file!, date);

      if (file == null) {
        emit(const FaceRegisterFailedPictureState());
        return;
      }

      DigitalPointEntity digitalPoint = DigitalPointEntity(
        date: date,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        typePoint: DigitalPointTypeEnum.rekognit,
        photoPath: file.path,
        status: DigitalPointStatusEnum.pending,
        captureType: DigitalPointCaptureTypeEnumUtils.fromTypeCapture(
            typeCaptureEnum: event.image.captureEnum),
        uniqueHash: const Uuid().v1(),
        tabletSession: session?.me.isTabletSession ?? false,
      );

      final result = await registerPointUsecase.call(
        RegisterPointParam(
          condoId: condoId,
          meId: meId,
          digitalPoint: digitalPoint,
          file: file,
        ),
      );

      DigitalPointState response = result.fold(
        (error) {
          if (error is KnownFailure) {
            if (error.code == DigitalPointRegisterFailure.serverError) {
              EmployeeAnalyticsLogEvents.logEvent(
                event: AnalyticsEventsEmployee
                    .homeRegistrarPontoDigitalSucessoOffline(),
                referenceValue:
                    sessionBloc.getSession?.condominium.reference.toString() ??
                        "",
              );
              return const FaceRegisterLoadedPictureState(
                  isOnlineRegister: false);
            }
            if (error.code ==
                DigitalPointRegisterFailure.onWorkLeaveNotAccepted) {
              EmployeeAnalyticsLogEvents.logEvent(
                event: AnalyticsEventsEmployee
                    .homeRegistrarPontoDigitalSucessoOffline(),
                referenceValue:
                    sessionBloc.getSession?.condominium.reference.toString() ??
                        "",
              );
              return FaceRegisterAwayPictureState(message: error.error);
            }
            if (error.code ==
                DigitalPointRegisterFailure.customRefusedMessage) {
              EmployeeAnalyticsLogEvents.logEvent(
                event: AnalyticsEventsEmployee
                    .homeRegistrarPontoDigitalFalhaIdentificacao(),
                referenceValue:
                    sessionBloc.getSession?.condominium.reference.toString() ??
                        "",
              );
              return FaceRegisterFailedPictureState(
                  TlsException(error.error?.detail));
            }
          }
          EmployeeAnalyticsLogEvents.logEvent(
            event: AnalyticsEventsEmployee
                .homeRegistrarPontoDigitalFalhaIdentificacao(),
            referenceValue:
                sessionBloc.getSession?.condominium.reference.toString() ?? "",
          );
          return const FaceRegisterFailedPictureState();
        },
        (s3) {
          myTrace.putAttribute("succes", "true");
          myTrace.stop();
          EmployeeAnalyticsLogEvents.logEvent(
            event: AnalyticsEventsEmployee.homeRegistrarPontoDigitalSucesso(),
            referenceValue:
                sessionBloc.getSession?.condominium.reference.toString() ?? "",
          );
          return const FaceRegisterLoadedPictureState(isOnlineRegister: true);
        },
      );

      if (event.mustSave) {
        var parsedMap = event.mapRegisteredPointDate ??
            {
              sessionBloc.getSession!.me.id: DateTime.now(),
            };

        parsedMap.update(
          sessionBloc.getSession!.me.id,
          (value) => DateTime.now(),
          ifAbsent: () => DateTime.now(),
        );

        await preferences.setString(
          SharedPreferencesKeys.registeredPointDate,
          json.encode(
            parsedMap.map(
              (key, value) => MapEntry(
                key,
                value?.toFormattedString(),
              ),
            ),
          ),
        );
      }

      result.fold(
        (l) {
          myTrace.putAttribute("succes", "false");
          if (l is KnownFailure && l.code != null) {
            myTrace.putAttribute("errorCode", l.code!);
          } else {
            myTrace.putAttribute("errorCode", "500");
          }
        },
        (r) {
          myTrace.putAttribute("succes", "true");
        },
      );

      await myTrace.stop();

      emit(response);
    } on TimeoutException catch (e) {
      emit(LocationTimeoutFailedPictureState(e));
    } catch (e) {
      emit(FaceRegisterFailedPictureState(e as Exception));
    }
  }

  Future<void> _mapSavePoint(
    SavePointEvent event,
    Emitter<DigitalPointState> emit,
  ) async {
    try {
      emit(const FaceLoadingPictureState());

      var session = sessionBloc.getSession;

      String condoId =
          session == null ? event.condoRef ?? "" : session.condominium.id;
      String meId =
          session == null ? event.employee?.idLogin ?? "" : session.me.id;
      DateTime date = DateTime.now();

      Position? position;

      if (session?.me.isTabletSession == false) {
        position = await _getPosition();
      }

      DigitalPointState response = const FaceLoadingPictureState();

      File? file = await convertFile(event.image.file!, date);

      if (file == null) {
        emit(const FaceRegisterFailedPictureState());
        return;
      }

      DigitalPointEntity entity = DigitalPointEntity(
        date: date,
        latitude: session?.me.isTabletSession == true
            ? session?.condominium.geographicCoordinates?.latitude.toString() ??
                ""
            : position?.latitude.toString() ?? "",
        longitude: session?.me.isTabletSession == true
            ? session?.condominium.geographicCoordinates?.longitude
                    .toString() ??
                ""
            : position?.longitude.toString() ?? "",
        typePoint: DigitalPointTypeEnum.offline,
        photoPath: file.path,
        status: DigitalPointStatusEnum.pending,
        captureType: DigitalPointCaptureTypeEnumUtils.fromTypeCapture(
          typeCaptureEnum: event.image.captureEnum,
        ),
        uniqueHash: const Uuid().v1(),
        tabletSession:
            session == null ? true : session.me.isTabletSession ?? false,
        numCad: event.employee?.numCad,
        reference: event.condoRef,
        numCra: event.employee?.numCra,
      );
      final result = await savePointUsecase.call(
        SavePointParam(model: entity, condoId: condoId, meId: meId),
      );
      response =
          result.fold((l) => const FaceRegisterFailedPictureState(), (r) {
        EmployeeAnalyticsLogEvents.logEvent(
          event:
              AnalyticsEventsEmployee.homeRegistrarPontoDigitalSucessoOffline(),
          referenceValue: session == null
              ? event.condoRef ?? ""
              : session.condominium.reference.toString(),
        );
        return const FaceRegisterLoadedPictureState(isOnlineRegister: false);
      });
      emit(response);
    } catch (e) {
      emit(FaceRegisterFailedPictureState(e as Exception));
    }
  }

  Position? _highPosition;
  Stopwatch? _startHighPosition;
  Future<void> _getHighPosition() async {
    _highPosition = null;
    if (_startHighPosition == null) {
      _startHighPosition = Stopwatch()..start();
    } else {
      _startHighPosition?.reset();
    }
    try {
      bool isOnline = await appConnectivity
          .checkConnectivity()
          .timeout(const Duration(seconds: 2), onTimeout: () => false);

      _highPosition =
          await GeolocationUtils.getUserGeolocationPosition(isOnline);
      // ignore: empty_catches
    } on Exception {}
  }

  Future<Position> _getPosition() async {
    if (_startHighPosition != null &&
        _startHighPosition!.elapsed <= const Duration(minutes: 1) &&
        _highPosition != null) {
      return _highPosition!;
    }

    Position position;

    if (sessionBloc.getSession?.lastPosition != null) {
      return sessionBloc.getSession!.lastPosition!;
    }

    bool isOnline = await appConnectivity
        .checkConnectivity()
        .timeout(const Duration(seconds: 2), onTimeout: () => false);

    var result = await GeolocationUtils.getUserGeolocationPosition(isOnline);

    position = result ?? getCondoPosition(sessionBloc.getSession);

    return position;
  }

  Future<Position> _getUserOrCondoPosition() async {
    late Position position;
    var session = sessionBloc.getSession;
    if (session?.me.isTabletSession == true) {
      position = getCondoPosition(session);
    } else {
      position = await _getPosition();
    }
    return position;
  }

  Position getCondoPosition(Session? session) {
    return Position(
        longitude:
            session?.condominium.geographicCoordinates?.longitudeDouble ?? 0,
        latitude:
            session?.condominium.geographicCoordinates?.latitudeDouble ?? 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
        speedAccuracy: 0);
  }

  Future<File?> convertFile(XFile xFile, DateTime date) async {
    String id = DateFormat("dd_MM_yyyy_HH_mm_ss").format(date);
    if (await CheckPermissions.storage()) {
      String dir = (await getApplicationDocumentsDirectory()).path;
      final Uint8List bytes = await xFile.readAsBytes();
      Image? image = decodeImage(bytes);
      if (image == null) {
        return null;
      }
      File fileConverted =
          await File("$dir/$id.jpg").writeAsBytes(encodeJpg(image));
      return fileConverted;
    }
    return null;
  }

  getSession() {
    return sessionBloc.getSession;
  }
}
