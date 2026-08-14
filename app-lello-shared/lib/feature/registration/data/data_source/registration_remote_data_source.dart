part of shared_features;

abstract class RegistrationRemoteDataSource {
  Future<RegistrationModel> post(RegistrationModel model, [int? idEmpresa]);
  Future<RegistrationLelloUserModel> get(String cpf);
  Future<RegisterFcmTokenModel> registerFcmToken(RegisterFcmTokenModel model);
  Future<bool> disableFcmToken(RegisterFcmTokenModel model);
}
