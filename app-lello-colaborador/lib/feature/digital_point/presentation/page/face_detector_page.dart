// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_bloc.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_event.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_state.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_register_error_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_register_success_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_request_error_page.dart';
import 'package:colaborador/feature/digital_point/presentation/page/location_timeout_error_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/shared_features.dart';

class FaceDetectorArgs {
  final DigitalTimesheetStatusEnum statusEnum;
  final bool isOnline;
  final EmployeeInfo? employee;
  final String? condoRef;

  FaceDetectorArgs({
    required this.statusEnum,
    required this.isOnline,
    required this.employee,
    required this.condoRef,
  });
}

enum FaceDetectorPageResult { sucess, locationDenied, camDenied, error }

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  FaceDetectorPageState createState() => FaceDetectorPageState();
}

class FaceDetectorPageState extends State<FaceDetectorPage>
    with WidgetsBindingObserver {
  late DigitalPointBloc bloc;
  late FaceDetectorArgs arguments;
  bool start = false;
  bool _hasCheckedPermissions = false;
  bool _isNavigatingToPermissionPage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc = ApplicationContainer.instance().resolve();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      arguments =
          ModalRoute.of(context)!.settings.arguments as FaceDetectorArgs;
      if (arguments.employee != null &&
          arguments.condoRef?.isNotEmpty == true) {
        if (arguments.employee?.statusEnum !=
            DigitalTimesheetStatusEnum.approved) {
          bloc.add(CancelPointEvent());
          log("Não pode bater ponto sem biometria cadastrada");
          Fluttertoast.showToast(
              msg: getString(context, "face_request_info"),
              toastLength: Toast.LENGTH_LONG);
          return;
        }
        _setUpPermissions();
        bloc.add(StatCameraCaptureEvent(
          statusEnum: arguments.employee!.statusEnum,
          condoRef: arguments.condoRef,
          employee: arguments.employee,
        ));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Removido o código que não é mais necessário
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<DigitalPointBloc, DigitalPointState>(
        listener: (context, state) async {
          if (state is FaceRegisterLoadedPictureState) {
            await Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.faceRegisterSuccess,
              arguments: FaceRegisterSuccessPageArgs(
                isOnlineRegister: state.isOnlineRegister,
              ),
            );
            return;
          }
          if (state is FaceRegisterAwayPictureState) {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: SizedBox(
                    width: size.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child:
                                SvgPicture.asset("assets/ic_billet_alert.svg"),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(
                                context, "digital_point_sync_dialog_title"),
                            textAlign: TextAlign.center,
                            style:
                                LelloTextStyles.subtitleBold(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight(),
                            ),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context,
                                "digital_point_unauthorized_dialog_message"),
                            style: LelloTextStyles.subtitle(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context,
                                "digital_point_unauthorized_away_message"),
                            style: LelloTextStyles.subtitle(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Dimens.spacing),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.all(Dimens.spacing),
                              child: Text(
                                getString(context, "ok"),
                                style: LelloTextStyles.subBody(theme)?.copyWith(
                                  color: LelloTheme.palleteOf(theme).primary(),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Launch.whatsApp(
                                context,
                                "551127977586",
                                message: getString(
                                  context,
                                  "whats_app_away_request_message",
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(Dimens.spacing),
                              child: Text(
                                "ENTRAR EM CONTATO",
                                style: LelloTextStyles.subBody(theme),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          if (state is FaceRegisterFailedPictureState) {
            await Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.faceRegisterError,
              arguments: FaceRegisterErrorPageArgs(
                statusEnum: arguments.statusEnum,
                isOnline: arguments.isOnline,
                employee: arguments.employee,
                condoRef: arguments.condoRef,
                knowException: state.ex,
              ),
            );
          }
          if (state is FaceRequestLoadedPictureState) {
            await Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.faceRequestSuccess,
            );
            return;
          }
          if (state is FaceRequestFailedPictureState) {
            await Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.faceRequestError,
              arguments: FaceRequestErrorPageArgs(
                statusEnum: arguments.statusEnum,
                isOnline: arguments.isOnline,
                knowException: state.ex,
                employee: arguments.employee,
                condoRef: arguments.condoRef,
              ),
            );
            return;
          }
          if (state is LocationTimeoutFailedPictureState) {
            await Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.faceLocationTimeoutError,
              arguments: LocationTimeoutErrorPageArgs(
                statusEnum: arguments.statusEnum,
                isOnline: arguments.isOnline,
                employee: arguments.employee,
                condoRef: arguments.condoRef,
                knowException: state.exception,
              ),
            );
            return;
          }
          if (state is FaceRequestNoFacePictureState) {
            await Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.faceRequestError,
              arguments: FaceRequestErrorPageArgs(
                statusEnum: arguments.statusEnum,
                isOnline: arguments.isOnline,
                employee: arguments.employee,
                condoRef: arguments.condoRef,
                knowException: const FormatException("no_face"),
              ),
            );
            return;
          }
          if (state is FaceRequestErrorPictureState) {
            await Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.faceRequestError,
              arguments: FaceRequestErrorPageArgs(
                statusEnum: arguments.statusEnum,
                isOnline: arguments.isOnline,
                employee: arguments.employee,
                condoRef: arguments.condoRef,
                knowException: const ProcessException("image", []),
              ),
            );
            return;
          }
          if (state is FaceRequestCanceledPictureState) {
            if (bloc.getSession() == null) {
              Navigator.pop(context);
            } else {
              Navigator.of(context)
                  .popUntil(ModalRoute.withName(SharedApplicationRoute.home));
            }
            return;
          }
        },
        builder: (context, state) {
          // Se o estado é de cancelamento, não mostrar loading infinito
          if (state is FaceRequestCanceledPictureState) {
            // Forçar navegação de volta após um frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                if (bloc.getSession() == null) {
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).popUntil(
                      ModalRoute.withName(SharedApplicationRoute.home));
                }
              }
            });
            return const Scaffold(
              body: Center(
                child: LoadingWidget(),
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: LoadingWidget(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _setUpPermissions() async {
    _hasCheckedPermissions = true;
    AcessSettingsPermissionsDeniedItemEnum? isDenied =
        await _checkAllPermissions();

    if (isDenied != null) {
      _isNavigatingToPermissionPage = true;
      final result = await Navigator.of(context).pushNamed(
        SharedApplicationRoute.accessSettingsPermissionDenied,
        arguments: AcessSettingsPermissionDeniedPageArgs(
          acessSettingsPermissionsDeniedItem:
              AcessSettingsPermissionsDeniedItem(
            item: isDenied,
            isColaboradorApp: true,
          ),
        ),
      );

      _isNavigatingToPermissionPage = false;

      // Se o usuário voltou sem conceder permissões, cancelar o processo
      if (result == null || result == false) {
        bloc.add(CancelPointEvent());
        return;
      }

      // Se retornou true, significa que as permissões foram concedidas
      if (result == true) {
        setState(() {
          start = true;
        });
        // Reiniciar o processo de captura de câmera
        bloc.add(StatCameraCaptureEvent(
          statusEnum: arguments.employee!.statusEnum,
          condoRef: arguments.condoRef,
          employee: arguments.employee,
        ));
        return;
      }

      // Como fallback, verificar novamente as permissões
      await _checkPermissionsAfterSettings();
    } else {
      setState(() {
        start = true;
      });
    }
  }

  Future<void> _checkPermissionsAfterSettings() async {
    AcessSettingsPermissionsDeniedItemEnum? isDenied =
        await _checkAllPermissions();

    if (isDenied == null) {
      // Permissões foram concedidas, continuar com o face detection
      setState(() {
        start = true;
      });
      // Reiniciar o processo de captura de câmera
      bloc.add(StatCameraCaptureEvent(
        statusEnum: arguments.employee!.statusEnum,
        condoRef: arguments.condoRef,
        employee: arguments.employee,
      ));
    } else {
      // Permissões ainda negadas, cancelar o processo
      bloc.add(CancelPointEvent());
    }
  }

  Future<AcessSettingsPermissionsDeniedItemEnum?> _checkAllPermissions() async {
    bool canGetLocation = await CheckPermissions.location();
    if (!canGetLocation) {
      return AcessSettingsPermissionsDeniedItemEnum.location;
    }

    bool canGetStorage = await CheckPermissions.storage();
    if (!canGetStorage) {
      return AcessSettingsPermissionsDeniedItemEnum.files;
    }

    bool canGetCamera = await CheckPermissions.camera();
    if (!canGetCamera) {
      return AcessSettingsPermissionsDeniedItemEnum.cam;
    }
    return null;
  }
}
