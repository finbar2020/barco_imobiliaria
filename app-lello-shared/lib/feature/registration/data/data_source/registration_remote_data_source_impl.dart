part of shared_features;

class RegistrationRemoteDataSourceImpl extends RegistrationRemoteDataSource {
  final RegistrationApi api;

  RegistrationRemoteDataSourceImpl({required this.api});
  @override
  Future<RegistrationModel> post(RegistrationModel model, [int? idEmpresa]) async {
    final response = await api.post(model, idEmpresa);
    return ApiMapper.map(response, (json) => RegistrationModel.fromJson(json));
  }

  @override
  Future<RegistrationLelloUserModel> get(String cpf) async {
    final response = await api.get(cpf);
    return ApiMapper.map(
        response, (json) => RegistrationLelloUserModel.fromJson(json));
  }

  @override
  Future<RegisterFcmTokenModel> registerFcmToken(
      RegisterFcmTokenModel model) async {
    final response = await api.registerFcmToken(model);

    return ApiMapper.map(
        response, (json) => RegisterFcmTokenModel.fromJson(json));
  }

  @override
  Future<bool> disableFcmToken(RegisterFcmTokenModel model) async {
    final response = await api.disableFcmToken(model);
    if (response.isSuccessful) {
      return true;
    } else {
      throw response.error ?? response;
    }
  }
}
