import 'package:essentials/essentials.dart';

class RemoteConfigStore {
  late FirebaseRemoteConfig remoteConfig;

  Future<bool> initFirebaseRemoteConfig() async {
    remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(hours: 12),
      ),
    );
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    return true;
  }

  Future<Map<String, RemoteConfigValue>> getAll() async =>
      remoteConfig.getAll();

  Future<RemoteConfigValue> getValue({required String key}) async =>
      remoteConfig.getValue(key);

  Future<void> setConfigSettings({
    required RemoteConfigSettings settings,
  }) async {
    await remoteConfig.setConfigSettings(settings);
  }
}
