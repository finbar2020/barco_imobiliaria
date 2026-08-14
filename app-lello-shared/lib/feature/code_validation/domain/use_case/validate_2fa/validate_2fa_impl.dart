part of shared_features;

class Validate2faImpl extends Validate2fa {
  final CodeValidationRepository repository;

  Validate2faImpl({required this.repository});

  @override
  Future<Try<CodeValidToken>> call(Validate2faParam params) async {
    try {
      var error = _validate(params);
      if (error != null) {
        return Rejection<CodeValidToken>(error);
      }
      return await repository.validate2faAsync(params.id, params.value);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure? _validate(Validate2faParam params) {
    if (params.id.isEmpty) return InvalidValidate2faFailure();
    if (params.value.isEmpty) return InvalidValidate2faFailure();
    return null;
  }
}
