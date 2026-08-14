import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_income.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_bloc.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_bloc_impl.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';
import '../../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  GetIncome getMonthlyIncome;
  SessionBloc sessionBloc;
  IncomeDashboardBloc bloc;

  var _data = Income();
  setUp(() {
    getMonthlyIncome = GetMonthlyIncomeMock();
    sessionBloc = SessionBlocMock();
    bloc = IncomeDashboardBlocImpl(
        sessionBloc: sessionBloc, getMonthlyIncome: getMonthlyIncome);
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
    when(getMonthlyIncome.call(any)).thenAnswer((_) async => Success(_data));
    bloc = IncomeDashboardBlocImpl(
        sessionBloc: sessionBloc, getMonthlyIncome: getMonthlyIncome);
    await expectLater(
        bloc,
        emitsInOrder([
          isA<IncomeDashboardLoadingState>(),
          IsAnd<IncomeDashboardLoadingState>((it) => it.data == _data),
          isA<IncomeDashboardLoadedState>()
        ]));
  }

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = IncomeDashboardBlocImpl(
          sessionBloc: sessionBloc, getMonthlyIncome: getMonthlyIncome);

      expect(
          bloc,
          emitsInOrder([
            isA<IncomeDashboardLoadingState>() //default state
          ]));
    });

    test(
        'Should call load residents use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(getMonthlyIncome.call(any)).thenAnswer((_) async => Success(_data));

      bloc = IncomeDashboardBlocImpl(
          sessionBloc: sessionBloc, getMonthlyIncome: getMonthlyIncome);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<IncomeDashboardLoadingState>(),
            IsAnd<IncomeDashboardLoadingState>((it) => it.data == _data)
          ]));

      verify(getMonthlyIncome.call(any));
    });
  });

  group('begin refresh', () {
    test('Should emit loading state when state is already loaded', () async {
      when(getMonthlyIncome.call(any)).thenAnswer((_) async => Success(_data));
      await setLoaded();
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<IncomeDashboardLoadedState>(),
            isA<IncomeDashboardLoadingState>(),
            isA<IncomeDashboardLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(getMonthlyIncome.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<IncomeDashboardLoadedState>(),
            isA<IncomeDashboardLoadingState>(),
            isA<IncomeDashboardLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(getMonthlyIncome.call(any)).thenAnswer((_) async => Success(_data));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<IncomeDashboardLoadingState>(),
          ]));
    });
  });
}

class GetMonthlyIncomeMock extends Mock implements GetIncome {}
