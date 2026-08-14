part of shared_features;

class AuthenticateImpl extends Authenticate {
  final AccessTokenRepository repository;
  final AuthenticateFirebase authenticateFirebase;

  AuthenticateImpl(
      {required this.repository, required this.authenticateFirebase});

  @override
  Future<Try<AccessToken?>> call(Credentials params) async {
    try {
      var error = _validate(params);
      if (error != null) {
        return Rejection<AccessToken>(error);
      }

      final token = await repository.post(params);
      return await token.fold((err) {
        return Rejection<AccessToken>(err);
      }, (token) async {
        final localPersistence = await repository.save(token!);
        await authenticateFirebase.call(token.firebaseToken!);
        return Success(localPersistence.getOrElse(() => token));
      });
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure? _validate(Credentials params) {
    if (params.username.isEmpty || params.password.isEmpty) {
      return InvalidCredentialsFailure("validate_credentials_failure", null);
    }
    return null;
  }
}
