part of shared_features;

abstract class CodeValidationRemoteDataSource {
  Future<CodeValidationModel> insertValidation(CodeValidationModel model);
  Future<CodeRequestModel> insertRequest(CodeRequestModel model);

  Future<CodeDataModel> getDados2faAsync(String cpf, [int? idEmpresa]);
  Future<bool> request2faAsync(String id, String appSignature);
  Future<CodeValidTokenModel> validate2faAsync(
      String hashToken, String tokenValue);
}
