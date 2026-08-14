part of shared_features;

class GetDados2faImpl extends GetDados2fa {
  final CodeValidationRepository repository;

  GetDados2faImpl({required this.repository});

  @override
  Future<Try<CodeData>> call(CodeDataParam params) async {
    try {
      var error = _validate(params);
      if (error != null) {
        return Rejection<CodeData>(error);
      }
      return await repository.getDados2faAsync(params.cpf, params.idEmpresa);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure? _validate(CodeDataParam params) {
    if (params.cpf.isEmpty) return InvalidGetDados2faFailure();
    return null;
  }
}
