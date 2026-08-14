part of shared_features;

abstract class RegistrationRepository {
  Future<Try<Registration>> post(Registration entity);
  Future<Try<RegistrationLelloUser>> get(String cpf);
  Future<Try<RegisterFcmToken>> registerFcmToken(
      RegisterFcmToken registerFcmToken);
  Future<Try<bool>> disableFcmToken(RegisterFcmToken registerFcmToken);
}
