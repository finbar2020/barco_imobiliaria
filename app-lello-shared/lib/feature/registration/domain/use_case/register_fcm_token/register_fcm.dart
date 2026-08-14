part of shared_features;

abstract class RegisterFcm
    extends UseCase<RegisterFcmToken, RegisterFcmTokenParams> {}

class RegisterFcmTokenParams {
  final RegisterFcmToken fcmToken;
  RegisterFcmTokenParams({required this.fcmToken});
}
