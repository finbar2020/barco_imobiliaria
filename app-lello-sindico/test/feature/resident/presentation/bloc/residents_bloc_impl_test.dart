import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_bloc.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_bloc_impl.dart';
import 'package:lello/feature/resident/presentation/bloc/residents_state.dart';
import 'package:lello/feature/resident/presentation/page/residents_page.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';
import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  ListResidents listResidents;
  SessionBloc sessionBloc;
  ResidentsBloc bloc;

  var _resident = Resident();
  setUp(() {
    listResidents = ListResidentsMock();
    sessionBloc = SessionBlocMock();
    bloc = ResidentsBlocImpl(
        sessionBloc: sessionBloc, listResidents: listResidents);
  });

  void setLoaded() async {
    final session = Session()..selectedCondominium = Condominium(id: "123");
    whenListen(sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
    when(listResidents.call(any)).thenAnswer((_) async => Success([_resident]));
    bloc = ResidentsBlocImpl(
        sessionBloc: sessionBloc, listResidents: listResidents);
    await expectLater(
        bloc,
        emitsInOrder([
          isA<ResidentsLoadingState>(),
          IsAnd<ResidentsLoadingState>((it) => it.data.length == 1),
          isA<ResidentsLoadedState>()
        ]));
  }

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = ResidentsBlocImpl(
          sessionBloc: sessionBloc, listResidents: listResidents);

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadingState>() //default state
          ]));
    });

    test(
        'Should call load residents use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listResidents.call(any))
          .thenAnswer((_) async => Success([_resident]));

      bloc = ResidentsBlocImpl(
          sessionBloc: sessionBloc, listResidents: listResidents);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadingState>(),
            IsAnd<ResidentsLoadingState>((it) => it.data.length == 1)
          ]));

      verify(listResidents.call(any));
    });
  });

  group('begin refresh', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listResidents.call(any))
          .thenAnswer((_) async => Success([_resident]));
      await setLoaded();
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadedState>(),
            isA<ResidentsLoadingState>(),
            isA<ResidentsLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listResidents.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadedState>(),
            isA<ResidentsLoadingState>(),
            isA<ResidentsLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listResidents.call(any))
          .thenAnswer((_) async => Success([_resident]));
      bloc.beginRefresh();

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadingState>(),
          ]));
    });
  });

  group('begin load next page', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listResidents.call(any))
          .thenAnswer((_) async => Success([_resident]));
      await setLoaded();
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadedState>(),
            isA<ResidentsPagingState>(),
            isA<ResidentsLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listResidents.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadedState>(),
            isA<ResidentsPagingState>(),
            isA<ResidentsPageFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listResidents.call(any))
          .thenAnswer((_) async => Success([_resident]));
      bloc.beginLoadNextPage();

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadingState>(),
          ]));
    });
  });

  group('begin search', () {
    test('Should emit loading state when state is already loaded', () async {
      when(listResidents.call(any))
          .thenAnswer((_) async => Success([_resident]));
      await setLoaded();
      bloc.beginSearch("1");

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadedState>(),
            isA<ResidentsSearchingState>(),
            isA<ResidentsLoadedState>()
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setLoaded();
      when(listResidents.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginSearch("1");

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadedState>(),
            IsAnd<ResidentsSearchingState>((it) => it.query == "1"),
            isA<ResidentsLoadFailedState>()
          ]));
    });

    test('Should not emit any new loading state when state is loading',
        () async {
      when(listResidents.call(any))
          .thenAnswer((_) async => Success([_resident]));
      bloc.beginSearch("1");

      expect(
          bloc,
          emitsInOrder([
            isA<ResidentsLoadingState>(),
          ]));
    });
  });
}

class ListResidentsMock extends Mock implements ListResidents {}
