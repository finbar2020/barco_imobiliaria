part of shared_features;

class CodeValidationRepositoryImpl extends CodeValidationRepository {
  final CodeValidationRemoteDataSource dataSource;

  CodeValidationRepositoryImpl({required this.dataSource});

  @override
  Future<Try<CodeValidation?>> validate(CodeValidation codeValidation) async {
    try {
      final model = CodeValidationModel.fromEntity(codeValidation);
      final result = await this.dataSource.insertValidation(model!);
      return Success(result.toEntity());
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure _mapApiFailure(ApiFailure err) {
    if (err.failure == RegistrationApi.user_not_found_failure)
      return RegistrationUserNotFoundFailure();
    if (err.failure == CodeValidationApi.code_previously_validated_failure)
      return RequestCodeAlreadyValidatedFailure();
    if (err.failure == CodeValidationApi.max_attempts_exceeded_failure)
      return ValidateCodeMaxAttemptsExceededFailure();
    if (err.status == 400) return UserUnkonwFailure();
    return UnknownFailure(err);
  }

  @override
  Future<Try<CodeRequest>> register(CodeRequest request) async {
    try {
      final model = CodeRequestModel.fromEntity(request);
      model?.appSignature = await SmsAutoFill().getAppSignature;
      final result = await this.dataSource.insertRequest(model!);
      result.cpf = model.cpf;
      result.source = model.source;
      result.origin = model.origin;
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<CodeData>> getDados2faAsync(String cpf, [int? idEmpresa]) async {
    try {
      final result = await this.dataSource.getDados2faAsync(cpf, idEmpresa);
      return Success(result.toEntity());
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<CodeValidToken>> validate2faAsync(
      String hashToken, String tokenValue) async {
    try {
      final result =
          await this.dataSource.validate2faAsync(hashToken, tokenValue);
      return Success(result.toEntity());
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<bool>> request2faAsync(String id, String appSignature) async {
    try {
      final result = await this.dataSource.request2faAsync(id, appSignature);
      return Success(result);
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
