part of shared_features;

class CodeValidationRemoteDataSourceImpl
    extends CodeValidationRemoteDataSource {
  final CodeValidationApi api;

  CodeValidationRemoteDataSourceImpl({required this.api});

  @override
  Future<CodeRequestModel> insertRequest(CodeRequestModel model) async {
    final response = await api.postRequest(model);
    return ApiMapper.map(response, (json) => CodeRequestModel.fromJson(json));
  }

  @override
  Future<CodeValidationModel> insertValidation(
      CodeValidationModel model) async {
    final response = await api.postValidation(model);

    if (response.statusCode == 202) return model;
    throw Exception(response.body);
  }

  @override
  Future<CodeDataModel> getDados2faAsync(String cpf, [int? idEmpresa]) async {
    final response = await api.getDados2faAsync(cpf, idEmpresa);
    return ApiMapper.map(response, (json) => CodeDataModel.fromJson(json));
  }

  @override
  Future<bool> request2faAsync(String id, String appSignature) async {
    final response = await api.request2faAsync(id, appSignature);

    if (response.statusCode == 200) return true;
    throw Exception(response.body);
  }

  @override
  Future<CodeValidTokenModel> validate2faAsync(
      String hashToken, String tokenValue) async {
    final response = await api.validate2faAsync(hashToken, tokenValue);

    return ApiMapper.map(
        response, (json) => CodeValidTokenModel.fromJson(json));
  }
}
