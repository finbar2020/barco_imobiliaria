import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/background/sync_digital_points_worker.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_bloc.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/init_sqflite_ffi.dart';
import '../../helpers/test_application_container.dart' show TestEnvironment;

/// Smoke test do grafo de dependências: monta o container real e resolve os
/// tipos usados pelas telas. Uma dependência esquecida no registro quebra
/// aqui, e não só em runtime.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  late ApplicationContainer container;

  setUp(() async {
    FlavorConfig.init();
    await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    Hive.init(Directory.systemTemp.createTempSync('colaborador_di').path);
    // `resetTestApplicationContainer` resolveria o `CircuitBreakerController`
    // para descartá-lo, e isso construiria o controller real (que abre um
    // stream do Firestore). Aqui basta o reset seco do get_it.
    await ApplicationContainer.instance().locator.reset(dispose: true);
    container = ApplicationContainer.instance();
    await container.setUp(TestEnvironment());
  });

  tearDown(() => ApplicationContainer.instance().locator.reset(dispose: true));

  test('registra o ambiente e a base url', () {
    expect(container.resolve<Environment>().name, 'test');
    expect(container.getBaseUrl(), 'http://localhost');
  });

  test('registra a infraestrutura compartilhada', () {
    expect(container.resolve<ChopperClient>(), isNotNull);
    expect(container.resolve<AppConnectivity>(), isNotNull);
    expect(container.resolve<Validator>(), isNotNull);
    expect(container.resolve<Uploader>(), isNotNull);
    expect(container.resolve<SyncDigitalPointsWorker>(), isNotNull);
  });

  test('registra os blocos e controllers das telas', () {
    expect(container.resolve<SessionBloc>(), isNotNull);
    expect(container.resolve<MeBloc>(), isNotNull);
    expect(container.resolve<DigitalPointBloc>(), isNotNull);
    expect(container.resolve<HomeController>(), isNotNull);
    expect(container.resolve<AuthenticationStore>(), isNotNull);
    expect(container.resolve<AuthenticationBloc>(), isNotNull);
  });

  test('registra os casos de uso de notificação', () {
    expect(container.resolve<GhostNotificationUsecase>(), isNotNull);
    expect(container.resolve<SendPushCallback>(), isNotNull);
    expect(container.resolve<GetNotifications>(), isNotNull);
  });

  test('resetLazySingleton recria a instância registrada', () {
    final first = container.resolve<AppConnectivity>();

    container.resetLazySingleton<AppConnectivity>();

    expect(identical(container.resolve<AppConnectivity>(), first), isFalse);
  });
}
