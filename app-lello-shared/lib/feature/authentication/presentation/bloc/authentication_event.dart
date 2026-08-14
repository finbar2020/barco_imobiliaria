part of shared_features;

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticateEvent extends AuthenticationEvent {
  final AccessToken accessToken;
  final bool? onLogin;
  final dynamic me;
  const AuthenticateEvent({
    required this.accessToken,
    this.onLogin,
    this.me,
  });

  @override
  List<Object?> get props => [accessToken, onLogin, me];
}

class AuthenticatingEvent extends AuthenticationEvent {
  const AuthenticatingEvent();
}

class LogoutEvent extends AuthenticationEvent {
  const LogoutEvent();
}

class UnauthenticateEvent extends AuthenticationEvent {
  const UnauthenticateEvent();
}

class LoadAuthenticationEvent extends AuthenticationEvent {
  const LoadAuthenticationEvent();
}

class UnauthorizedEvent extends AuthenticationEvent {
  final Failure? error;
  final bool restartApp;
  const UnauthorizedEvent({
    this.error,
    required this.restartApp,
  });

  @override
  List<Object?> get props => [error, restartApp];
}

class AuthenticationFailedEvent extends AuthenticationEvent {
  final Failure error;
  const AuthenticationFailedEvent({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class SwitchAuthenticationEvent extends AuthenticationEvent {
  final AccessToken? token;
  final String? role;
  const SwitchAuthenticationEvent({this.token, this.role});

  @override
  List<Object?> get props => [token, role];
}
