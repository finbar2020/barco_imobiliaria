import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/pendency/domain/entity/pendency.dart';
import 'package:lello/feature/pendency/domain/use_case/list_pendency/list_pendency.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_bloc_impl.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  DashboardBloc bloc;
  ListPendency listPendency;
  SessionBloc sessionBloc;

  final _condominium = Condominium();
  final _me = Me();
  final List<Pendency> _data = [Pendency(id: "123")];
  final session = Session()
    ..selectedCondominium = _condominium
    ..me = _me;
//
  setUp(() {
    listPendency = ListPendencyMock();
    sessionBloc = SessionBlocMock();

    bloc =
        DashboardBlocImpl(listPendency: listPendency, sessionBloc: sessionBloc);
  });

  group('on sesion changes', () {
    test('Should not load pendency when session is not loaded yet', () async {
      whenListen<SessionEvent, SessionState>(
          sessionBloc, Stream.value(SessionLoadingState(null)));
      bloc = DashboardBlocImpl(
          listPendency: listPendency, sessionBloc: sessionBloc);

      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<DashboardState>((it) => it.data.isEmpty), //default state
          ]));
    });

    test('Should load pendency when session is loaded', () async {
      whenListen<SessionEvent, SessionState>(
          sessionBloc, Stream.value(SessionLoadedState(session)));
      bloc = DashboardBlocImpl(
          listPendency: listPendency, sessionBloc: sessionBloc);

      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<DashboardState>((it) => it.data.isEmpty), //default state
            isA<DashboardLoadingState>(),
          ]));
    });

    test(
        'Should call load pendency use case when session is loaded and no cache is available',
        () async {
      whenListen<SessionEvent, SessionState>(
          sessionBloc, Stream.value(SessionLoadedState(session)));
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.local))))
          .thenAnswer((_) async => Success([]));
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.remote))))
          .thenAnswer((_) async => Success(_data));

      bloc = DashboardBlocImpl(
          listPendency: listPendency, sessionBloc: sessionBloc);

      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<DashboardState>((it) => it.data.isEmpty), //default state
            isA<DashboardLoadingState>(),
            IsAnd<DashboardState>((it) => it.data == _data),
          ]));

      verify(listPendency.call(any));
    });
  });

  group('begin refresh', () {
    setUp(() {
      whenListen<SessionEvent, SessionState>(
          sessionBloc, Stream.value(SessionLoadedState(session)));
      bloc = DashboardBlocImpl(
          listPendency: listPendency, sessionBloc: sessionBloc);
    });

    test('Should call list pendendency use case', () async {
      when(listPendency.call(any)).thenAnswer((_) async => Success(_data));
      bloc.beginRefresh();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<DashboardState>(), //default state
            isA<DashboardState>(), //loaded cache state
          ]));

      await verify(listPendency.call(any));
    });

    test('Should emit refreshing state', () async {
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.local))))
          .thenAnswer((_) async => Success([]));
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.remote))))
          .thenAnswer((_) async => Success(_data));

      bloc.beginRefresh();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<DashboardState>(), //default state
            isA<DashboardLoadingState>(),
            isA<DashboardState>(), //default state
            isA<DashboardRefreshingState>(), //loaded cache state
            isA<DashboardState>(), //loaded cache state
          ]));
    });

    test('Should emit failure state when list pendency succeeds', () async {
      final failure = UnknownFailure(null);
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.local))))
          .thenAnswer((_) async => Success([]));
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.remote))))
          .thenAnswer((_) async => Rejection(failure));
      bloc.beginRefresh();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<DashboardState>(), //default state
            isA<DashboardLoadingState>(), //default state
            isA<DashboardState>(), //loaded cache state
            isA<DashboardRefreshingState>(), //loaded cache state
            isA<DashboardFailedState>(), //loaded cache state
          ]));
    });
  });

  group('begin load next page', () {
    setUp(() {
      whenListen<SessionEvent, SessionState>(
          sessionBloc, Stream.value(SessionLoadedState(session)));
      bloc = DashboardBlocImpl(
          listPendency: listPendency, sessionBloc: sessionBloc);
    });

    test('Should call list pendendency use case', () async {
      when(listPendency.call(any)).thenAnswer((_) async => Success(_data));
      bloc.beginLoadNextPage();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<DashboardState>(), //default state
            isA<DashboardState>(), //loaded cache state
          ]));

      await verify(listPendency.call(any));
    });

    test('Should emit paging state', () async {
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.local))))
          .thenAnswer((_) async => Success([]));
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.remote))))
          .thenAnswer((_) async => Success(_data));

      bloc.beginLoadNextPage();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<DashboardState>(), //default state
            isA<DashboardLoadingState>(),
            isA<DashboardState>(), //loaded cache state
            isA<DashboardPagingState>(),
            isA<DashboardState>(),
          ]));
    });

    test('Should emit failure state when list pendency succeeds', () async {
      final failure = UnknownFailure(null);
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.local))))
          .thenAnswer((_) async => Success([]));
      when(listPendency.call(argThat(IsAnd<ListPendencyParam>(
              (it) => it.dataOrigin == DataOrigin.remote))))
          .thenAnswer((_) async => Rejection(failure));
      bloc.beginLoadNextPage();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<DashboardState>(), //default state
            isA<DashboardLoadingState>(), //default state
            isA<DashboardState>(), //loaded cache state
            isA<DashboardPagingState>(), //loaded cache state
            isA<DashboardPageFailedState>(), //loaded cache state
          ]));
    });
  });
}

class ListPendencyMock extends Mock implements ListPendency {}

class SessionBlocMock extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}
