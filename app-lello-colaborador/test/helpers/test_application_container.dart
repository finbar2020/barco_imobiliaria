import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_bloc.dart';
import 'package:colaborador/feature/digital_point/controllers/digital_point_controller.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_pending_points_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_by_status_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_usecase.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_bloc.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_bloc.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/configs/environment.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures.dart';

class TestEnvironment extends Environment {
  TestEnvironment()
      : super(
          name: 'test',
          isProduction: false,
          apiUrl: 'http://localhost',
        );
}

class TestCircuitBreakerController extends CircuitBreakerController {
  TestCircuitBreakerController({
    required SessionBloc sessionBloc,
    this.visible = true,
  }) : super(
          database: FakeFirebaseFirestore(),
          sessionBloc: sessionBloc,
          environment: TestEnvironment(),
        );

  final bool visible;

  @override
  bool checkVisible({
    required String applicationRbac,
    required String reference,
    bool hasHortaCheck = false,
  }) =>
      visible;
}

class LoadedSessionBloc extends Fake implements SessionBloc {
  LoadedSessionBloc([Session? session])
      : session = session ?? testSession(),
        loadedState = SessionLoadedState(
          session: session ?? testSession(),
          isTabletSession: false,
        );

  final Session session;
  final SessionLoadedState loadedState;

  @override
  SessionState get state => loadedState;

  @override
  Session? get getSession => session;

  @override
  Stream<SessionState> get stream => Stream.value(loadedState);

  @override
  bool checkRback(String rbac) => true;

  @override
  bool get iSPreferencesPersonalizationActive => true;
}

class _FakeConnectivity extends Fake implements AppConnectivity {
  @override
  bool isConnected(List<ConnectivityResult> result) => true;

  @override
  Future<bool> isOfflineMode() async => false;
}

class _FakeRegisterFcm extends Fake implements RegisterFcm {}

class _FakeGetToken extends Fake implements GetToken {
  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async =>
      Success(AccessToken()..accessToken = 't');
}

class _FakeGhost extends Fake implements GhostNotificationUsecase {}

class _FakeAuthStore extends Fake implements AuthenticationStore {}

class _FakeGetPoints extends Fake implements GetPointsUsecase {
  @override
  Future<Try<List<DigitalPointEntity>>> call(GetPointsParam? params) async =>
      Success(const []);
}

class _FakeGetByStatus extends Fake implements GetPointsByStatusUsecase {
  @override
  Future<Try<List<DigitalPointEntity>>> call(
    GetPointsByStatusParam? params,
  ) async =>
      Success(const []);
}

class _FakeDigitalPointController extends Fake implements DigitalPointController {
  @override
  Future<bool?> hasUserRangeAllowed() async => true;
}

class FakeGetProof extends Fake implements GetProofUseCase {
  FakeGetProof({
    this.fail = false,
    this.empty = false,
    this.nullProofName = false,
  });

  final bool fail;
  final bool empty;
  final bool nullProofName;

  @override
  Future<Try<List<ProofEntity>>> call(GetProofParams params) async {
    if (fail) return Rejection(KnownFailure('500', 'erro'));
    if (empty) return Success(const []);
    return Success([
      ProofEntity(
        nsr: 1,
        dateTimeClockIn: '10/01/2026 08:00',
        proofName: nullProofName ? null : 'p1.pdf',
      ),
      ProofEntity(
        nsr: 2,
        dateTimeClockIn: '10/01/2026 12:00',
        proofName: 'p2.pdf',
      ),
    ]);
  }
}

class FakeGetProofFile extends Fake implements GetProofFileUseCase {
  @override
  Future<Try<ProofFileEntity>> call(GetProofFileParams params) async =>
      Success(ProofFileEntity(contentBytes: 'YWJj'));
}

class _FakeGetInfoByCondoCode extends Fake implements GetInfoByCondoCodeUseCase {
  @override
  Future<Try<CondominiumCodeInfo>> call(GetInfoByCondoCodeParams params) async =>
      Rejection(UnknownFailure('unused'));
}

class FakeGetPendingPoints extends Fake implements GetPendingPointsUsecase {
  FakeGetPendingPoints({
    this.fail = false,
    this.empty = false,
    this.points,
  });

  final bool fail;
  final bool empty;
  final List<DigitalPointEntity>? points;

  @override
  Future<Try<List<DigitalPointEntity>>> call([void params]) async {
    if (fail) return Rejection(UnknownFailure('points'));
    if (empty) return Success(const []);
    return Success(points ?? [testPoint()]);
  }
}

class _FakeSyncWorker extends Fake implements SyncDigitalPointsWorker {
  @override
  Future<bool> syncPoints() async => true;
}

class TestProofScope {
  TestProofScope(this.proofBloc);

  final ProofBloc proofBloc;

  Future<void> dispose() async {
    await proofBloc.close();
    await resetTestApplicationContainer();
  }
}

class TestTabletAuthScope {
  TestTabletAuthScope(this.bloc);

  final AuthenticationTabletBloc bloc;

  Future<void> dispose() async {
    await bloc.close();
    await resetTestApplicationContainer();
  }
}

class TestApplicationContainerScope {
  TestApplicationContainerScope._({
    required this.homeBloc,
    required this.registerPointBloc,
    required this.homeController,
    required this.registerPointController,
    required this.sessionBloc,
  });

  final HomeBloc homeBloc;
  final RegisterPointBloc registerPointBloc;
  final HomeController homeController;
  final RegisterPointController registerPointController;
  final LoadedSessionBloc sessionBloc;

  Future<void> dispose() async {
    await homeBloc.close();
    await registerPointBloc.close();
    homeController.pageController?.dispose();
    await resetTestApplicationContainer();
  }
}

Future<TestApplicationContainerScope> installTestApplicationContainer({
  Session? session,
  bool circuitVisible = true,
  PageController? pageController,
}) async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }

  final sessionBloc = LoadedSessionBloc(session);
  final homeBloc = HomeBloc(
    registerFcm: _FakeRegisterFcm(),
    sessionBloc: sessionBloc,
    deviceIdentifierService: DeviceIdentifierService(),
  );
  final homeController = HomeController(
    getPointsUsecase: _FakeGetPoints(),
    getPointsByStatusUsecase: _FakeGetByStatus(),
    sessionBloc: sessionBloc,
    connectivity: _FakeConnectivity(),
    homeBloc: homeBloc,
    authenticationStore: _FakeAuthStore(),
    getToken: _FakeGetToken(),
  )..ghostNotificationUsecase = _FakeGhost();
  homeController.pageController =
      pageController ?? PageController(initialPage: 1);

  final registerPointBloc = RegisterPointBloc();
  final registerPointController = RegisterPointController(
    appConnectivity: _FakeConnectivity(),
    sessionBloc: sessionBloc,
    registerPointBloc: registerPointBloc,
    digitalPointController: _FakeDigitalPointController(),
  );

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(sessionBloc);
  locator.registerSingleton<HomeController>(homeController);
  locator.registerSingleton<RegisterPointController>(registerPointController);
  locator.registerSingleton<CircuitBreakerController>(
    TestCircuitBreakerController(
      sessionBloc: sessionBloc,
      visible: circuitVisible,
    ),
  );
  locator.registerFactory<Validator>(() => ValidatorImpl());

  return TestApplicationContainerScope._(
    homeBloc: homeBloc,
    registerPointBloc: registerPointBloc,
    homeController: homeController,
    registerPointController: registerPointController,
    sessionBloc: sessionBloc,
  );
}

Future<void> installTestCircuitBreaker({
  LoadedSessionBloc? sessionBloc,
  bool circuitVisible = true,
}) async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }

  final session = sessionBloc ?? LoadedSessionBloc();
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(session);
  locator.registerSingleton<CircuitBreakerController>(
    TestCircuitBreakerController(
      sessionBloc: session,
      visible: circuitVisible,
    ),
  );
}

Future<void> installTestValidator() async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerFactory<Validator>(() => ValidatorImpl());
}

Future<TestProofScope> installTestProofContainer({
  bool failProof = false,
  bool empty = false,
  bool nullProofName = false,
}) async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }

  final sessionBloc = LoadedSessionBloc();
  final proofBloc = ProofBloc(
    getProofUseCase: FakeGetProof(
      fail: failProof,
      empty: empty,
      nullProofName: nullProofName,
    ),
    getProofFileUseCase: FakeGetProofFile(),
    sessionBloc: sessionBloc,
  );

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(sessionBloc);
  locator.registerSingleton<ProofBloc>(proofBloc);
  locator.registerFactory<Validator>(() => ValidatorImpl());

  return TestProofScope(proofBloc);
}

Future<TestTabletAuthScope> installTestTabletAuth({
  bool fail = false,
  bool empty = false,
  List<DigitalPointEntity>? points,
}) async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }

  final bloc = AuthenticationTabletBloc(
    getInfoByCondoCodeUseCase: _FakeGetInfoByCondoCode(),
    getPendingPointsUsecase: FakeGetPendingPoints(
      fail: fail,
      empty: empty,
      points: points,
    ),
    syncPoints: _FakeSyncWorker(),
  );

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<AuthenticationTabletBloc>(bloc);

  return TestTabletAuthScope(bloc);
}

Future<void> resetTestApplicationContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<CircuitBreakerController>()) {
    final circuit = locator<CircuitBreakerController>();
    if (circuit is TestCircuitBreakerController) {
      circuit.dispose();
    }
  }
  await locator.reset(dispose: true);
}
