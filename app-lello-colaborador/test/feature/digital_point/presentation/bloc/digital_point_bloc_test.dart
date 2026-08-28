import 'dart:convert';
import 'dart:io';

import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_register_failure.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/register_point/register_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/request_digital_point/request_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/save_point/save_point.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_bloc.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_event.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_state.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../../../helpers/fake_permission_handler.dart';
import '../../../../helpers/firebase_mocks.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/test_application_container.dart';

const _pngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAE'
    'hQGAhKmMIQAAAABJRU5ErkJggg==';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;

  @override
  Future<String?> getTemporaryPath() async => path;
}

class _FakeConnectivity extends Fake implements AppConnectivity {
  _FakeConnectivity({this.online = true});

  final bool online;

  @override
  Future<bool> checkConnectivity() async => online;
}

class _FakeRequestDigital extends Fake implements RequestDigitalUsecase {
  _FakeRequestDigital({this.fail = false});

  final bool fail;
  int calls = 0;

  @override
  Future<Try<bool>> call(RequestDigitalParam? params) async {
    calls++;
    if (fail) return Rejection(UnknownFailure('request'));
    return Success(true);
  }
}

class _FakeRegisterPoint extends Fake implements RegisterPointUsecase {
  _FakeRegisterPoint({this.failure});

  final Failure? failure;
  final registered = <DigitalPointEntity>[];

  @override
  Future<Try<DigitalPointEntity>> call(RegisterPointParam? params) async {
    registered.add(params!.digitalPoint);
    if (failure != null) return Rejection(failure!);
    return Success(params.digitalPoint);
  }
}

class _FakeSavePoint extends Fake implements SavePointUsecase {
  _FakeSavePoint({this.fail = false});

  final bool fail;
  final saved = <DigitalPointEntity>[];

  @override
  Future<Try<DigitalPointEntity>> call(SavePointParam? params) async {
    saved.add(params!.model);
    if (fail) return Rejection(UnknownFailure('save'));
    return Success(params.model);
  }
}

class _FakeCameraPicker extends Fake
    implements GetImageFromCameraViewPickerUsecase {}

class _FakeSessionBloc extends Fake implements SessionBloc {
  _FakeSessionBloc({this.isTabletSession = true});

  final bool isTabletSession;

  @override
  Session? get getSession {
    final condo = testCondominium();
    final me = testMe(condominiums: [condo], isTabletSession: isTabletSession)
      ..isTabletSession = isTabletSession;
    return Session(me: me, condominium: condo);
  }

  @override
  SessionState get state => const SessionInitialState();

  @override
  Stream<SessionState> get stream => const Stream.empty();
}

class _FakeInactivityCubit extends Fake implements InactivityCubit {}

/// O bloc lê `error.error?.detail` na recusa com mensagem própria.
class _RefusedError {
  _RefusedError(this.detail);

  final String detail;
}

late Directory _tempDir;

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<InactivityCubit>(_FakeInactivityCubit());
}

CameraViewPickerResult _picture() {
  final file = File('${_tempDir.path}/colaborador_face.png');
  file.writeAsBytesSync(base64Decode(_pngBase64));
  return CameraViewPickerResult(
    captureEnum: TypeCaptureEnum.manual,
    file: XFile(file.path),
  );
}

DigitalPointBloc _bloc({
  _FakeRequestDigital? requestDigital,
  _FakeSavePoint? savePoint,
  _FakeRegisterPoint? registerPoint,
  bool isTabletSession = true,
  bool online = true,
}) {
  final bloc = DigitalPointBloc(
    appConnectivity: _FakeConnectivity(online: online),
    requestDigitalUsecase: requestDigital ?? _FakeRequestDigital(),
    registerPointUsecase: registerPoint ?? _FakeRegisterPoint(),
    getImageFromCameraViewPickerUsecase: _FakeCameraPicker(),
    savePointUsecase: savePoint ?? _FakeSavePoint(),
    sessionBloc: _FakeSessionBloc(isTabletSession: isTabletSession),
  );
  addTearDown(bloc.close);
  return bloc;
}

Future<DigitalPointState> _waitFor(
  DigitalPointBloc bloc,
  bool Function(DigitalPointState) test,
) =>
    bloc.stream.firstWhere(test);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setUpFakeFirebase();
    _tempDir = Directory.systemTemp.createTempSync('colaborador_dp');
    PathProviderPlatform.instance = _FakePathProvider(_tempDir.path);
    setFakePermissionHandler(
      FakePermissionHandler(status: PermissionStatus.granted),
    );
    await _installContainer();
  });

  tearDown(() async {
    await resetTestApplicationContainer();
    if (_tempDir.existsSync()) _tempDir.deleteSync(recursive: true);
  });

  group('DigitalPointBloc', () {
    test('começa aguardando a captura da foto', () {
      final bloc = _bloc();

      expect(bloc.state, isA<FaceInitialPictureState>());
    });

    test('cancelar o ponto emite o estado de cancelamento', () async {
      final bloc = _bloc();

      bloc.add(const CancelPointEvent());

      expect(
        await _waitFor(bloc, (s) => s is FaceRequestCanceledPictureState),
        isA<FaceRequestCanceledPictureState>(),
      );
    });

    test('cadastro facial pendente envia a foto para análise', () async {
      final request = _FakeRequestDigital();
      final bloc = _bloc(requestDigital: request);

      bloc.add(SendFaceEvent(
        image: _picture(),
        statusEnum: DigitalTimesheetStatusEnum.pending,
        mustSave: false,
      ));

      expect(
        await _waitFor(bloc, (s) => s is FaceRequestLoadedPictureState),
        isA<FaceRequestLoadedPictureState>(),
      );
      expect(request.calls, 1);
    });

    test('falha no envio do cadastro facial emite erro', () async {
      final bloc = _bloc(requestDigital: _FakeRequestDigital(fail: true));

      bloc.add(SendFaceEvent(
        image: _picture(),
        statusEnum: DigitalTimesheetStatusEnum.pending,
        mustSave: false,
      ));

      expect(
        await _waitFor(bloc, (s) => s is FaceRequestFailedPictureState),
        isA<FaceRequestFailedPictureState>(),
      );
    });

    test('salvar ponto offline guarda o registro pendente', () async {
      final savePoint = _FakeSavePoint();
      final bloc = _bloc(savePoint: savePoint);

      bloc.add(SavePointEvent(image: _picture(), condoRef: 'R1'));

      final state = await _waitFor(
        bloc,
        (s) => s is FaceRegisterLoadedPictureState,
      ) as FaceRegisterLoadedPictureState;

      expect(state.isOnlineRegister, isFalse);
      expect(savePoint.saved.single.status.name, 'pending');
      expect(savePoint.saved.single.tabletSession, isTrue);
    });

    test('falha ao salvar o ponto offline emite erro', () async {
      final bloc = _bloc(savePoint: _FakeSavePoint(fail: true));

      bloc.add(SavePointEvent(image: _picture(), condoRef: 'R1'));

      expect(
        await _waitFor(bloc, (s) => s is FaceRegisterFailedPictureState),
        isA<FaceRegisterFailedPictureState>(),
      );
    });

    test('sem conexão e sem biometria aprovada o ponto é cancelado', () async {
      final bloc = _bloc(online: false);

      bloc.sendFile(
        file: _picture(),
        statusEnum: DigitalTimesheetStatusEnum.pending,
        mustSave: false,
      );

      expect(
        await _waitFor(bloc, (s) => s is FaceRequestCanceledPictureState),
        isA<FaceRequestCanceledPictureState>(),
      );
    });

    test('sem conexão e com biometria aprovada o ponto é salvo local',
        () async {
      final savePoint = _FakeSavePoint();
      final bloc = _bloc(savePoint: savePoint, online: false);

      bloc.sendFile(
        file: _picture(),
        statusEnum: DigitalTimesheetStatusEnum.approved,
        mustSave: true,
        condoRef: 'R1',
      );

      await _waitFor(bloc, (s) => s is FaceRegisterLoadedPictureState);
      expect(savePoint.saved, hasLength(1));
    });
  });

  group('DigitalPointBloc registro online', () {
    SendFaceEvent registerEvent() => SendFaceEvent(
          image: _picture(),
          statusEnum: DigitalTimesheetStatusEnum.approved,
          mustSave: false,
        );

    test('registro aceito emite sucesso online', () async {
      final registerPoint = _FakeRegisterPoint();
      final bloc = _bloc(registerPoint: registerPoint);

      bloc.add(registerEvent());

      final state = await _waitFor(
        bloc,
        (s) => s is FaceRegisterLoadedPictureState,
      ) as FaceRegisterLoadedPictureState;

      expect(state.isOnlineRegister, isTrue);
      expect(registerPoint.registered.single.typePoint,
          DigitalPointTypeEnum.rekognit);
    });

    test('servidor fora do ar salva o ponto como offline', () async {
      final bloc = _bloc(
        registerPoint: _FakeRegisterPoint(
          failure: KnownFailure(DigitalPointRegisterFailure.serverError, 'off'),
        ),
      );

      bloc.add(registerEvent());

      final state = await _waitFor(
        bloc,
        (s) => s is FaceRegisterLoadedPictureState,
      ) as FaceRegisterLoadedPictureState;

      expect(state.isOnlineRegister, isFalse);
    });

    test('colaborador afastado recebe o aviso de afastamento', () async {
      final bloc = _bloc(
        registerPoint: _FakeRegisterPoint(
          failure: KnownFailure(
            DigitalPointRegisterFailure.onWorkLeaveNotAccepted,
            'afastado',
          ),
        ),
      );

      bloc.add(registerEvent());

      expect(
        await _waitFor(bloc, (s) => s is FaceRegisterAwayPictureState),
        isA<FaceRegisterAwayPictureState>(),
      );
    });

    test('recusa com mensagem própria emite falha', () async {
      final bloc = _bloc(
        registerPoint: _FakeRegisterPoint(
          failure: KnownFailure(
            DigitalPointRegisterFailure.customRefusedMessage,
            _RefusedError('rosto não reconhecido'),
          ),
        ),
      );

      bloc.add(registerEvent());

      expect(
        await _waitFor(bloc, (s) => s is FaceRegisterFailedPictureState),
        isA<FaceRegisterFailedPictureState>(),
      );
    });

    test('falha desconhecida emite falha de registro', () async {
      final bloc = _bloc(
        registerPoint: _FakeRegisterPoint(failure: UnknownFailure('erro')),
      );

      bloc.add(registerEvent());

      expect(
        await _waitFor(bloc, (s) => s is FaceRegisterFailedPictureState),
        isA<FaceRegisterFailedPictureState>(),
      );
    });

    test('sendFile online encaminha para o registro', () async {
      final registerPoint = _FakeRegisterPoint();
      final bloc = _bloc(registerPoint: registerPoint);

      bloc.sendFile(
        file: _picture(),
        statusEnum: DigitalTimesheetStatusEnum.approved,
        mustSave: false,
      );

      await _waitFor(bloc, (s) => s is FaceRegisterLoadedPictureState);
      expect(registerPoint.registered, hasLength(1));
    });
  });
}
