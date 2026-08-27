import 'dart:async';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/firebase_mocks.dart';
import 'expired_session_support.dart';

void main() {
  late FakeLogout logout;
  late FakeClearData clearData;
  late int emptied;
  late ExpiredSessionBloc bloc;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    logout = FakeLogout();
    clearData = FakeClearData();
    emptied = 0;
    bloc = ExpiredSessionBloc(
      clearDataUseCase: clearData,
      logOutUseCase: logout,
      emptySessionState: () => emptied++,
    );
  });

  tearDown(() => bloc.close());

  test('começa vazio', () {
    expect(bloc.state, const ExpiredSessionEmptyState());
  });

  test('beginLogOut desloga, limpa os dados, esvazia a sessão e registra',
      () async {
    final states = <ExpiredSessionState>[];
    bloc.stream.listen(states.add);

    bloc.beginLogOut(ExpiredSessionArguments(
      reason: 'token expirado',
      cpf: '123',
      accessToken: 'a',
      refreshToken: 'r',
      failure: 'f',
      information: ['x'],
    ));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(states, [
      const ExpiredSessionLogOutLoadingState(),
      const ExpiredSessionLogOutLoadedState(),
    ]);
    expect(logout.calls, 1);
    expect(clearData.calls, 1);
    expect(emptied, 1);
  });

  test('sem argumentos registra N/A', () async {
    bloc.beginLogOut(null);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state, const ExpiredSessionLogOutLoadedState());
    expect(emptied, 1);
  });

  test('setEmptySessionState chama o callback', () {
    bloc.setEmptySessionState();
    expect(emptied, 1);
  });

  test('eventos e estados comparam pelos props', () {
    final args = ExpiredSessionArguments(reason: 'r');
    expect(ExpiredSessionLogOutEvent(args).props, [args]);
    expect(const ExpiredSessionLogOutEvent(null), const ExpiredSessionLogOutEvent(null));
    expect(const ExpiredSessionEmptyState().props, isEmpty);
    expect(const ExpiredSessionLogOutLoadingState(),
        isNot(const ExpiredSessionLogOutLoadedState()));
  });

  test('espera o logout terminar antes de carregar', () async {
    final completer = Completer<Try<Nothing>>();
    logout.pending = completer;

    bloc.beginLogOut(null);
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, const ExpiredSessionLogOutLoadingState());

    completer.complete(Success(Nothing()));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state, const ExpiredSessionLogOutLoadedState());
  });
}
