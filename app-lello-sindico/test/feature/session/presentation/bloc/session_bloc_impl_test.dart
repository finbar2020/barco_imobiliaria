import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  SessionBloc bloc;
  AuthenticationBloc loginBloc;
  LoadSession loadSession;
  SaveSession saveSession;

  final _session = Session();
  final _failure = UnknownFailure(null);

  setUp(() {
    loginBloc = AuthenticateBlocMock();
    loadSession = LoadSessionMock();
    saveSession = SaveSessionMock();
    bloc = SessionBloc(
        authenticationBloc: loginBloc,
        loadSession: loadSession,
        saveSesion: saveSession);
  });

  group('beginLoadSession', () {
    test('Should call get me use case', () async {
      when(loadSession.call(any)).thenAnswer((_) async => Success(_session));
      bloc.beginLoadSession();
      await expectLater(
          bloc,
          emitsInOrder([
            isA<SessionState>(),
            isA<SessionLoadingState>(),
          ]));
      verify(loadSession.call(any));
    });

    test('Should emit session failed state when get me fails', () async {
      when(loadSession.call(any)).thenAnswer((_) async => Rejection(_failure));
      bloc.beginLoadSession();
      expectLater(
          bloc,
          emitsInOrder([
            isA<SessionState>(),
            isA<SessionLoadingState>(),
            isA<SessionFailedState>(),
          ]));
    });

    test('Should emit session loaded state when get me succeeds', () async {
      when(loadSession.call(any)).thenAnswer((_) async => Success(_session));
      bloc.beginLoadSession();
      expectLater(
          bloc,
          emitsInOrder([
            isA<SessionState>(),
            isA<SessionLoadingState>(),
            IsAnd<SessionLoadedState>((state) => state.session == _session),
          ]));
    });
  });

  group('on authentication changes', () {
    test('Should load me automatically when user authenticates', () async {
      whenListen(
          loginBloc,
          Stream.fromIterable(
              [AuthenticatedState(accessToken: AccessToken())]));
      when(loadSession.call(any)).thenAnswer((_) async => Success(_session));
      bloc = SessionBloc(
          authenticationBloc: loginBloc,
          loadSession: loadSession,
          saveSesion: saveSession);

      expectLater(
          bloc,
          emitsInOrder([
            isA<SessionState>(),
            isA<SessionLoadingState>(),
            IsAnd<SessionLoadedState>((state) => state.session == _session),
          ]));
    });

    test('Should not load me when user is not authenticated', () async {
      whenListen(loginBloc, Stream.fromIterable([UnauthenticatedState()]));
      bloc = SessionBloc(
          authenticationBloc: loginBloc,
          loadSession: loadSession,
          saveSesion: saveSession);

      expectLater(
          bloc,
          emitsInOrder([
            isA<SessionState>(),
          ]));
    });
  });

  group('selectCondominium,', () {
    test('Should emit session loaded state when selected condominium changes',
        () async {
      final condominium = Condominium();
      bloc.selectCondominium(condominium);
      expectLater(
          bloc,
          emitsInOrder([
            isA<SessionState>(),
            IsAnd<SessionLoadedState>(
                (state) => state.session.selectedCondominium == condominium),
          ]));
    });
  });
  group('updateMe,', () {
    test(
        'Should emit session loaded state when current state is session loaded',
        () async {
      final me = Me();
      bloc.updateMe(me);
      expectLater(
          bloc,
          emitsInOrder([
            isA<SessionState>(),
            IsAnd<SessionLoadedState>((state) => state.session.me == me),
          ]));
    });
  });
}

class LoadSessionMock extends Mock implements LoadSession {}

class SaveSessionMock extends Mock implements SaveSession {}

class AuthenticateBlocMock
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}
