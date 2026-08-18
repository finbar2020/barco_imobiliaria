import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_bloc.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  CondominiumBalanceBloc bloc;
  LoadCondominiumBalance loadBalance;
  SessionBloc sessionBloc;

  final _balance = CondominiumBalance();

  setUp(() {
    loadBalance = LoadConcominiumBalanceMock();
    sessionBloc = SessionBlocMock();
    bloc = CondominiumBalanceBlocImpl(
        loadCondominiumBalance: loadBalance, sessionBloc: sessionBloc);
  });

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = CondominiumBalanceBlocImpl(
          loadCondominiumBalance: loadBalance, sessionBloc: sessionBloc);

      expectLater(bloc, emitsInOrder([isA<CondominiumBalanceIdleState>()]));
    });

    test(
        'Should call load balance use case when session contains selected condominium and loadBalance succeeds',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(loadBalance.call(
              new CondominiumBalanceParam(id: session.selectedCondominium.id)))
          .thenAnswer((_) async => Success(_balance));

      bloc = CondominiumBalanceBlocImpl(
          loadCondominiumBalance: loadBalance, sessionBloc: sessionBloc);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<CondominiumBalanceIdleState>(),
            isA<CondominiumBalanceLoadingState>()
          ]));

      verify(loadBalance.call(
          new CondominiumBalanceParam(id: session.selectedCondominium.id)));
    });

    test(
        'Should emit loading and success state when session contains selected condominium and loadBalance succeeds',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(loadBalance.call(
              new CondominiumBalanceParam(id: session.selectedCondominium.id)))
          .thenAnswer((_) async => Success(_balance));

      bloc = CondominiumBalanceBlocImpl(
          loadCondominiumBalance: loadBalance, sessionBloc: sessionBloc);

      expectLater(
          bloc,
          emitsInOrder([
            isA<CondominiumBalanceIdleState>(),
            isA<CondominiumBalanceLoadingState>(),
            IsAnd<CondominiumBalanceLoadedState>((it) => it.balance == _balance)
          ]));
    });

    test(
        'Should emit loading and failed state when session contains selected condominium and loadBalance fails',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(loadBalance.call(
              new CondominiumBalanceParam(id: session.selectedCondominium.id)))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      bloc = CondominiumBalanceBlocImpl(
          loadCondominiumBalance: loadBalance, sessionBloc: sessionBloc);

      expectLater(
          bloc,
          emitsInOrder([
            isA<CondominiumBalanceIdleState>(),
            isA<CondominiumBalanceLoadingState>(),
            IsAnd<CondominiumBalanceFailedState>(
                (it) => it.failure is UnknownFailure)
          ]));
    });
  });
}

class SessionBlocMock extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}

class LoadConcominiumBalanceMock extends Mock
    implements LoadCondominiumBalance {}
