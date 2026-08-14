part of shared_features;

class AuthenticateFirebaseImpl extends AuthenticateFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Try<bool>> call(String params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    try {
      await _auth.signInWithCustomToken(params);
      return Success(true);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Failure? _validate(String? params) {
    if (params?.isNotEmpty != true) return InvalidParamFailure();
    return null;
  }
}
