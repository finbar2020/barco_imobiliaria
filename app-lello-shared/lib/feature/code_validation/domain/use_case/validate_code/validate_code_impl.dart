part of shared_features;

class ValidateCodeImpl extends ValidateCode {
  final CodeValidationRepository repository;

  ValidateCodeImpl({required this.repository});

  @override
  Future<Try<CodeValidation?>> call(CodeValidation params) async {
    try {
      var error = _validate(params);
      if (error != null) {
        return Rejection<CodeValidation>(error);
      }

      final result = await repository.validate(params);

      if (result is Rejection)
        return Rejection(InvalidCodeValidationFailure());
      else
        return result;
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure? _validate(CodeValidation params) {
    if (params.code == null) return InvalidCodeValidationFailure();
    if (params.code!.isEmpty) return InvalidCodeValidationFailure();

    return null;
  }
}
