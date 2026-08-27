import 'package:essentials/configs/environment.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
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

/// Registra no container o mínimo para código que resolve
/// `CircuitBreakerController`/`SessionBloc`/`Environment` globalmente
/// (ex.: `HomeItemEnum.checkVisible`).
///
/// O `circuitBreakController` de `home_item_enum.dart` é uma variável global
/// resolvida uma única vez por isolate, então dentro de um mesmo arquivo de
/// teste reaproveite o [FakeSessionBloc] devolvido e altere seus campos.
Future<CircuitBreakerController> installTestCircuitBreaker({
  FakeSessionBloc? sessionBloc,
}) async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  final session = sessionBloc ?? FakeSessionBloc();
  final circuit = CircuitBreakerController(
    database: FakeFirebaseFirestore(),
    sessionBloc: session,
    environment: TestEnvironment(),
  );
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(session);
  locator.registerSingleton<CircuitBreakerController>(circuit);
  return circuit;
}

Future<void> installTestEnvironment() async {
  SharedPreferences.setMockInitialValues({});
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
}

Future<void> resetTestApplicationContainer() async {
  final locator = ApplicationContainer.instance().locator;
  await locator.reset(dispose: true);
}

/// Aguarda [condition] virar verdadeira (polling), útil para blocs com fakes.
Future<void> waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('waitFor: condição não satisfeita em $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
