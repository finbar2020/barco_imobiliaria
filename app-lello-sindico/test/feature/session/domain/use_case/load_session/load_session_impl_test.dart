import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:lello/feature/session/data/model/session_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  LoadSession loadSession;
  GetMe getMe;
  SessionRepository sessionRepository;

  final _me = Me();
  final _sessionModel = SessionModel()..selectedCondominium = "1";

  setUp(() {
    getMe = GetMeMock();
    sessionRepository = SessionRepositoryMock();
    loadSession = LoadSessionImpl(getMe: getMe, repository: sessionRepository);
  });

  group('call', () {
    test('Should call getMe use case and session repository ', () async {
      final origin = DataOrigin.local;
      when(getMe.call(origin)).thenAnswer((_) async => Success(_me));
      when(sessionRepository.select())
          .thenAnswer((_) async => Success(_sessionModel));
      await loadSession.call(origin);

      verify(getMe.call(origin));
      verify(sessionRepository.select());
    });

    test(
        'Should return expected session with me entity and selected condominium when it is contained in me',
        () async {
      final condo = Condominium(id: "1");
      final expected = Me()..condominiums = [condo];

      final origin = DataOrigin.local;
      when(getMe.call(origin)).thenAnswer((_) async => Success(expected));
      when(sessionRepository.select())
          .thenAnswer((_) async => Success(_sessionModel));

      final result = await loadSession.call(origin);
      expect(
          result,
          IsAnd<Success<Session>>((it) =>
              it.get().me == expected &&
              it.get().selectedCondominium == condo));
    });

    test(
        'Should return expected session with me entity and selected first condominium when it is not contained in me',
        () async {
      final condo = Condominium(id: "2");
      final expected = Me()..condominiums = [condo, Condominium(id: "3")];

      final origin = DataOrigin.local;
      when(getMe.call(origin)).thenAnswer((_) async => Success(expected));
      when(sessionRepository.select())
          .thenAnswer((_) async => Success(_sessionModel));

      final result = await loadSession.call(origin);
      expect(
          result,
          IsAnd<Success<Session>>((it) =>
              it.get().me == expected &&
              it.get().selectedCondominium == condo));
    });
  });
}

class GetMeMock extends Mock implements GetMe {}

class SessionRepositoryMock extends Mock implements SessionRepository {}
