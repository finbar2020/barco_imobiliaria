part of shared_features;

abstract class CodeValidationRepository {
  Future<Try<CodeRequest>> register(CodeRequest request);
  Future<Try<CodeValidation?>> validate(CodeValidation validation);

  Future<Try<CodeData>> getDados2faAsync(String cpf, [int? idEmpresa]);
  Future<Try<bool>> request2faAsync(String id, String appSignature);
  Future<Try<CodeValidToken>> validate2faAsync(
      String hashToken, String tokenValue);
}
