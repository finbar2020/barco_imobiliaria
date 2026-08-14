import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/income/domain/use_case/get_billets.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_bloc.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_bloc_impl.dart';
import 'package:lello/feature/income/presentation/billets/bloc/billets_state.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_bloc.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_bloc_impl.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_state.dart';
import 'package:lello/feature/resident/presentation/page/residents_page.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/use_case/list_units/list_units.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../matcher/is_and_matcher.dart';
import '../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  ListUnits listUnits;
  SessionBloc sessionBloc;
  BilletsBloc bloc;

  var _unit = Unit();
  setUp(() {
    listUnits = ListUnitsMock();
    sessionBloc = SessionBlocMock();
    bloc = BilletsBlocImpl(sessionBloc: sessionBloc, listUnits: listUnits);
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
    when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));
    bloc = BilletsBlocImpl(sessionBloc: sessionBloc, listUnits: listUnits);
    await expectLater(
        bloc,
        emitsInOrder([
          isA<BilletsLoadingState>(),
          IsAnd<BilletsLoadingState>((it) => it.data.length == 1),
          isA<BilletsLoadedState>()
        ]));
  }

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = BilletsBlocImpl(sessionBloc: sessionBloc, listUnits: listUnits);

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadingState>() //default state
          ]));
    });

    test(
        'Should call load residents use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));

      bloc = BilletsBlocImpl(sessionBloc: sessionBloc, listUnits: listUnits);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<BilletsLoadingState>(),
            IsAnd<BilletsLoadingState>((it) => it.data.length == 1)
          ]));

      verify(listUnits.call(any));
    });
  });

  group('begin refresh', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));
      await setLoaded();
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadedState>(),
            isA<BilletsLoadingState>(),
            isA<BilletsLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listUnits.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadedState>(),
            isA<BilletsLoadingState>(),
            isA<BilletsLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadingState>(),
          ]));
    });
  });

  group('begin load next page', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));
      await setLoaded();
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadedState>(),
            isA<BilletsPagingState>(),
            isA<BilletsLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listUnits.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadedState>(),
            isA<BilletsPagingState>(),
            isA<BilletsPageFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadingState>(),
          ]));
    });
  });

  group('begin search', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));
      await setLoaded();
      bloc.beginSearch("1", "");

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadedState>(),
            isA<BilletsSearchingState>(),
            isA<BilletsLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listUnits.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginSearch("1", "");

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadedState>(),
            IsAnd<BilletsSearchingState>((it) => it.query == "1"),
            isA<BilletsLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listUnits.call(any)).thenAnswer((_) async => Success([_unit]));
      bloc.beginSearch("1", "");

      expect(
          bloc,
          emitsInOrder([
            isA<BilletsLoadingState>(),
          ]));
    });
  });
}

class ListUnitsMock extends Mock implements ListUnits {}
