part of shared_features;

class Request2faImpl extends Request2fa {
  final CodeValidationRepository repository;

  Request2faImpl({required this.repository});

  @override
  Future<Try<bool>> call(Tequest2faParam params) async {
    try {
      var error = _validate(params);
      if (error != null) {
        return Rejection<bool>(error);
      }
      return await repository.request2faAsync(params.id, params.appSignature);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure? _validate(Tequest2faParam params) {
    if (params.id.isEmpty) return InvalidRequest2faFailure();
    return null;
  }
}
