part of shared_features;

class DisableFcmImpl extends DisableFcm {
  final RegistrationRepository repository;
  final AccessTokenRepository accessTokenRepository;

  DisableFcmImpl(
      {required this.repository, required this.accessTokenRepository});

  @override
  Future<Try<bool>> call() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId = "";
    RegisterFcmToken fcmToken = RegisterFcmToken();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    fcmToken.deviceId = deviceId;

    var curentToken = (await accessTokenRepository.select()).fold(
      (l) => null,
      (r) => r,
    );
    fcmToken.refreshToken = curentToken?.refreshToken;

    final result = await repository.disableFcmToken(fcmToken);

    return result;
  }
}
