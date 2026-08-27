import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'authentication_support.dart';

void main() {
  late AuthenticationBloc bloc;

  setUp(() {
    bloc = AuthenticationBloc();
  });

  tearDown(() => bloc.close());

  test('começa desautenticado', () {
    expect(bloc.state, const UnauthenticatedState());
  });

  test('cada evento emite o estado correspondente', () async {
    final token = buildToken();
    final failure = UnknownFailure('x');
    final states = <AuthenticationState>[];
    final sub = bloc.stream.listen(states.add);

    bloc
      ..add(const AuthenticatingEvent())
      ..add(AuthenticateEvent(accessToken: token, onLogin: true, me: 'eu'))
      ..add(AuthenticationFailedEvent(error: failure))
      ..add(const LogoutEvent())
      ..add(UnauthorizedEvent(error: failure, restartApp: true))
      ..add(const UnauthenticateEvent());
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [
      const AuthenticatingState(),
      AuthenticatedState(accessToken: token, onLogin: true, me: 'eu'),
      AuthenticationFailedState(error: failure),
      const LogoutState(),
      UnautorizedState(error: failure, restartApp: true),
      const UnauthenticatedState(),
    ]);
  });

  test('estados e eventos comparam pelos props', () {
    final token = buildToken();
    final failure = UnknownFailure('x');

    expect(AuthenticatedState(accessToken: token, onLogin: true),
        AuthenticatedState(accessToken: token, onLogin: true));
    expect(AuthenticatedState(accessToken: token, onLogin: true),
        isNot(AuthenticatedState(accessToken: token, onLogin: false)));
    expect(UnautorizedState(error: failure, restartApp: false).props,
        [failure, false]);
    expect(AuthenticationFailedState(error: failure), isA<UnauthenticatedState>());
    expect(AuthenticationFailedState(error: failure).props, [failure]);
    expect(const AuthenticatingState().props, isEmpty);
    expect(const LogoutState(), const LogoutState());

    expect(AuthenticateEvent(accessToken: token, onLogin: true, me: 1).props,
        [token, true, 1]);
    expect(UnauthorizedEvent(error: failure, restartApp: true).props,
        [failure, true]);
    expect(AuthenticationFailedEvent(error: failure).props, [failure]);
    expect(SwitchAuthenticationEvent(token: token, role: 'R').props,
        [token, 'R']);
    expect(const LoadAuthenticationEvent().props, isEmpty);
    expect(const LogoutEvent(), const LogoutEvent());
    expect(const UnauthenticateEvent(), const UnauthenticateEvent());
  });
}
