part of shared_features;

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class UnauthenticatedState extends AuthenticationState {
  const UnauthenticatedState();
}

class UnautorizedState extends AuthenticationState {
  final Failure? error;
  final bool restartApp;
  const UnautorizedState({required this.error, required this.restartApp});

  @override
  List<Object?> get props => [error, restartApp];
}

class AuthenticatingState extends AuthenticationState {
  const AuthenticatingState();
}

class LogoutState extends AuthenticationState {
  const LogoutState();
}

class AuthenticatedState extends AuthenticationState {
  final AccessToken accessToken;
  final bool? onLogin;
  final dynamic me;
  const AuthenticatedState({required this.accessToken, this.onLogin, this.me});

  @override
  List<Object?> get props => [accessToken, onLogin, me];
}

class AuthenticationFailedState extends UnauthenticatedState {
  final Failure error;
  const AuthenticationFailedState({required this.error});

  @override
  List<Object?> get props => [error];
}
