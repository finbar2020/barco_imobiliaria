part of shared_features;

class RequestValidationCodeImpl extends RequestValidationCode {
  final CodeValidationRepository repository;

  RequestValidationCodeImpl({required this.repository});

  @override
  Future<Try<CodeRequest>> call(CodeRequest params) async {
    try {
      var error = _validate(params);
      if (error != null) {
        return Rejection(error);
      }

      final result = await repository.register(params);
      return result;
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure? _validate(CodeRequest? params) {
    if (params == null) return InvalidParamFailure();
    if (params.value.isEmpty) return InvalidCodeSourceFailure();
    if (params.token.length < 4) return InvalidCodeValidationFailure();

    return null;
  }
}
