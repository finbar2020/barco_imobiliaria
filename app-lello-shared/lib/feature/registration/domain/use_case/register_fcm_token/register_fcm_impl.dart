part of shared_features;

class RegisterFcmImpl extends RegisterFcm {
  final RegistrationRepository repository;

  RegisterFcmImpl({required this.repository});

  @override
  Future<Try<RegisterFcmToken>> call(RegisterFcmTokenParams params) async {
    final error = _validate(params);
    if (error != null) {
      return Rejection(error);
    }

    debugPrint("registerFcmToken: Start");
    final persisted = await repository.registerFcmToken(params.fcmToken);
    debugPrint("registerFcmToken: Finish");
    return persisted;
  }

  Failure? _validate(RegisterFcmTokenParams? params) {
    if (params == null) return InvalidRegistrationFailure();
    return null;
  }
}
