import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_bloc.dart';
import 'package:lello/feature/condominium/presentation/detail/bloc/condominium_balance_detail_state.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_bloc.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_bloc_impl.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_units.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';
import '../../../../dashboard/presentation/bloc/dashboard_bloc_impl_test.dart';

void main() {
  LoadCondominiumBalanceDetail loadCondominiumBalanceDetail;
  SessionBloc sessionBloc;
  BalanceDetailBloc bloc;

  var _detail = CondominiumBalanceDetail();
  setUp(() {
    loadCondominiumBalanceDetail = LoadCondominiumBalanceDetailMock();
    sessionBloc = SessionBlocMock();
    bloc = BalanceDetailBloc(
      sessionBloc: sessionBloc,
      loadCondominiumBalanceDetail: loadCondominiumBalanceDetail,
    );
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
    when(loadCondominiumBalanceDetail.call(any))
        .thenAnswer((_) async => Success(_detail));
    bloc = BalanceDetailBloc(
        sessionBloc: sessionBloc,
        loadCondominiumBalanceDetail: loadCondominiumBalanceDetail);
    await expectLater(
        bloc,
        emitsInOrder([
          isA<BalanceDetailLoadingState>(),
          isA<BalanceDetailLoadingState>(),
          IsAnd<BalanceDetailLoadedState>(((it) => it.data != null)),
        ]));
  }

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = BalanceDetailBloc(
          sessionBloc: sessionBloc,
          loadCondominiumBalanceDetail: loadCondominiumBalanceDetail);

      expect(
          bloc,
          emitsInOrder([
            isA<BalanceDetailLoadingState>(), //default state
          ]));
    });

    test(
        'Should call load residents use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(loadCondominiumBalanceDetail.call(any))
          .thenAnswer((_) async => Success(_detail));

      bloc = BalanceDetailBloc(
          sessionBloc: sessionBloc,
          loadCondominiumBalanceDetail: loadCondominiumBalanceDetail);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<BalanceDetailLoadingState>(),
            isA<BalanceDetailLoadingState>(),
            IsAnd<BalanceDetailLoadedState>((it) => it.data != null)
          ]));

      verify(loadCondominiumBalanceDetail.call(any));
    });
  });

  group('begin refresh', () {
    test('Should emit loading state when state is already loaded', () async {
      when(loadCondominiumBalanceDetail.call(any))
          .thenAnswer((_) async => Success(_detail));
      await setLoaded();
      bloc.beginRefresh(CondominiumBalanceDetailFilter());

      expect(
          bloc,
          emitsInOrder([
            isA<BalanceDetailLoadedState>(),
            isA<BalanceDetailLoadingState>(),
            isA<BalanceDetailLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(loadCondominiumBalanceDetail.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh(CondominiumBalanceDetailFilter());

      expect(
          bloc,
          emitsInOrder([
            isA<BalanceDetailLoadedState>(),
            isA<BalanceDetailLoadingState>(),
            isA<BalanceDetailLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(loadCondominiumBalanceDetail.call(any))
          .thenAnswer((_) async => Success(_detail));
      bloc.beginRefresh(CondominiumBalanceDetailFilter());

      expect(
          bloc,
          emitsInOrder([
            isA<BalanceDetailLoadingState>(),
          ]));
    });
  });
}

class LoadCondominiumBalanceDetailMock extends Mock
    implements LoadCondominiumBalanceDetail {}
