part of shared_features;

class RefreshTokenImpl extends RefreshToken {
  final RefreshTokenRepository repository;
  final AuthenticationBloc authenticationBloc;

  RefreshTokenImpl({
    required this.repository,
    required this.authenticationBloc,
  });

  @override
  Future<Try<AccessToken?>> call() async {
    try {
      final token = await repository.refreshToken();
      var result = await token.fold((err) {
        throw err;
      }, (token) async {
        final localPersistence = await repository.save(token, role: "");
        return localPersistence.getOrElse(() => token);
      });

      if (authenticationBloc.state is AuthenticatedState && result != null) {
        final authState = (authenticationBloc.state as AuthenticatedState);
        final me = authState.me;
        final preserveSelectedRolePermissions =
            authState.accessToken.selectedRolePermissions;
        result.selectedRolePermissions = preserveSelectedRolePermissions;
        authenticationBloc.add(
            AuthenticateEvent(accessToken: result, onLogin: false, me: me));
      } else {
        throw UnknownFailure("Refresh token failed");
      }
      return Success(result);
    } on BadRefreshTokenFailure catch (ex) {
      // bad refresh token failure quer dizer que token passado não é valido, precisa deslogar o usuário
      authenticationBloc.add(UnauthorizedEvent(error: ex, restartApp: true));
      await repository.clear();
      return Rejection(ex);
    } catch (ex) {
      //falha generica, só notificar usuario para tela de erro
      return Rejection(UnknownFailure(ex));
    }
  }
}
