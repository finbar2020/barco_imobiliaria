part of shared_features;

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const UnauthenticatedState()) {
    on<LogoutEvent>(handleLogoutEvent);
    on<UnauthenticateEvent>(handleUnauthenticateEvent);
    on<AuthenticateEvent>(handleAuthenticateEvent);
    on<UnauthorizedEvent>(handleUnauthorizedEvent);
    on<AuthenticatingEvent>(handleAuthenticatingEvent);
    on<AuthenticationFailedEvent>(handleAuthenticationFailedEvent);
  }

  void handleLogoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) {
    emit(const LogoutState());
  }

  void handleUnauthenticateEvent(
      UnauthenticateEvent event, Emitter<AuthenticationState> emit) {
    emit(const UnauthenticatedState());
  }

  void handleAuthenticateEvent(
      AuthenticateEvent event, Emitter<AuthenticationState> emit) {
    emit(
      AuthenticatedState(
        accessToken: event.accessToken,
        onLogin: event.onLogin,
        me: event.me,
      ),
    );
  }

  void handleUnauthorizedEvent(
      UnauthorizedEvent event, Emitter<AuthenticationState> emit) {
    emit(
      UnautorizedState(
        error: event.error,
        restartApp: event.restartApp,
      ),
    );
  }

  void handleAuthenticatingEvent(
      AuthenticatingEvent event, Emitter<AuthenticationState> emit) {
    emit(const AuthenticatingState());
  }

  void handleAuthenticationFailedEvent(
      AuthenticationFailedEvent event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationFailedState(error: event.error));
  }
}
