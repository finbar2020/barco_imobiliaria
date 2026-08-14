part of shared_features;

abstract class SharedApplicationContainer {
  T resolve<T extends Object>();
  String getBaseUrl();

  FutureOr resetLazySingleton<T extends Object>();
}
