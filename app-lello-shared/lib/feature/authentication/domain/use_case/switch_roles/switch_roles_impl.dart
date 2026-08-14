part of shared_features;

class SwitchRolesImpl extends SwitchRoles {
  final AccessTokenRepository repository;
  final AuthenticateFirebase authenticateFirebase;

  SwitchRolesImpl(
      {required this.repository, required this.authenticateFirebase});

  @override
  Future<Try<AccessToken?>> call(SwitchParams params) async {
    try {
      final token = await repository.switchRoles(params.role);
      return await token.fold((err) {
        return Rejection<AccessToken>(err);
      }, (token) async {
        final localPersistence =
            await repository.save(token, role: params.name);
        await authenticateFirebase.call(token!.firebaseToken!);
        return Success(localPersistence.getOrElse(() => token));
      });
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
