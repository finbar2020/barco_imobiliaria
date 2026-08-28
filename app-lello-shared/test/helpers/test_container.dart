import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:shared_features/shared_features.dart';

/// Implementação de [SharedApplicationContainer] para testes: um get_it
/// próprio onde cada teste registra os objetos (reais ou fakes) que a tela
/// sob teste resolve via `appContainer.resolve<T>()`.
///
/// ```dart
/// final container = TestSharedContainer()
///   ..register<AuthenticationStore>(store)
///   ..registerFactory<SomeBloc>(() => SomeBloc());
/// await pumpPage(tester, LoginPage(appContainer: container, ...));
/// ```
class TestSharedContainer extends SharedApplicationContainer {
  TestSharedContainer({this.baseUrl = 'http://localhost'});

  final GetIt locator = GetIt.asNewInstance();
  final String baseUrl;

  void register<T extends Object>(T instance) {
    if (locator.isRegistered<T>()) locator.unregister<T>();
    locator.registerSingleton<T>(instance);
  }

  void registerLazy<T extends Object>(T Function() factory) {
    if (locator.isRegistered<T>()) locator.unregister<T>();
    locator.registerLazySingleton<T>(factory);
  }

  void registerFactory<T extends Object>(T Function() factory) {
    if (locator.isRegistered<T>()) locator.unregister<T>();
    locator.registerFactory<T>(factory);
  }

  bool isRegistered<T extends Object>() => locator.isRegistered<T>();

  @override
  T resolve<T extends Object>() => locator<T>();

  @override
  String getBaseUrl() => baseUrl;

  @override
  FutureOr resetLazySingleton<T extends Object>() =>
      locator.resetLazySingleton<T>();

  Future<void> reset() => locator.reset(dispose: true);
}
