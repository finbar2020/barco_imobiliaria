import 'package:colaborador/core/bloc/inactivity/inactivity_cubit.dart';
import 'package:colaborador/core/bloc/inactivity/inactivity_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

FakeSessionBloc _tabletSession({SessionState? state}) {
  final me = testMe(isTabletSession: true);
  final bloc = FakeSessionBloc(testSessionOf(me));
  if (state != null) bloc.currentState = state;
  return bloc;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InactivityCubit — contagem regressiva', () {
    test('sessão não-tablet não emite estados', () {
      fakeAsync((async) {
        final cubit = InactivityCubit(sessionBloc: FakeSessionBloc());
        final states = <InactivityState>[];
        final sub = cubit.stream.listen(states.add);

        cubit.start();
        async.elapse(const Duration(seconds: 5));

        expect(states, isEmpty);
        cubit.periodicTimer?.cancel();
        sub.cancel();
      });
    });

    test('emite ChangeTimeState a cada segundo em sessão tablet', () {
      fakeAsync((async) {
        final cubit = InactivityCubit(sessionBloc: _tabletSession());
        final states = <InactivityState>[];
        final sub = cubit.stream.listen(states.add);

        cubit.start();
        async.elapse(const Duration(seconds: 3));

        expect(states.length, 3);
        expect(states.first, isA<ChangeTimeState>());
        expect((states.first as ChangeTimeState).timer, 59);
        expect((states.last as ChangeTimeState).timer, 57);

        cubit.periodicTimer?.cancel();
        sub.cancel();
      });
    });

    test('start novamente cancela o timer anterior', () {
      fakeAsync((async) {
        final cubit = InactivityCubit(sessionBloc: _tabletSession());
        cubit.start();
        final first = cubit.periodicTimer;

        cubit.start();

        expect(first?.isActive, isFalse);
        expect(cubit.isActive(), isTrue);
        expect(cubit.countDown, cubit.duration - 1);

        cubit.periodicTimer?.cancel();
        async.flushTimers();
      });
    });

    test('expira e emite TimeoutExpiredState com sessão carregada', () {
      fakeAsync((async) {
        final bloc = _tabletSession(state: SessionLoadedState(session: testSession(), isTabletSession: true));
        final cubit = InactivityCubit(sessionBloc: bloc);
        final states = <InactivityState>[];
        final sub = cubit.stream.listen(states.add);

        cubit.start();
        async.elapse(const Duration(seconds: 61));

        expect(states.last, isA<TimeoutExpiredState>());
        expect(cubit.isActive(), isFalse);
        sub.cancel();
      });
    });

    test('sem sessão carregada reinicia a contagem ao expirar', () {
      fakeAsync((async) {
        final cubit = InactivityCubit(sessionBloc: _tabletSession());

        cubit.start();
        async.elapse(const Duration(seconds: 61));

        expect(cubit.periodicTimer, isNull);
        expect(cubit.countDown, cubit.duration - 1);
        expect(cubit.isActive(), isFalse);
      });
    });
  });
}
