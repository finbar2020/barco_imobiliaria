import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/session/data/model/session_model.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  SessionRepository repository;
  SaveSession saveSession;

  final _session = Session();

  setUp(() {
    repository = SessionRepositoryMock();
    saveSession = SaveSessionImpl(repository: repository);
  });

  group('call', () {
    test('Should return InvalidParamsFailure if params is null', () async {
      Try<Session> result = await saveSession(null);
      expect(result,
          IsAnd<Rejection<Session>>((it) => it.get() is InvalidParamFailure));
    });

    test('Should call repository save', () async {
      when(repository.save(_session))
          .thenAnswer((_) async => Success(SessionModel()));
      await saveSession(_session);
      verify(repository.save(_session));
    });

    test('Should return success if repository succeeds saving', () async {
      when(repository.save(_session))
          .thenAnswer((_) async => Success(SessionModel()));
      Try<Session> result = await saveSession(_session);
      expect(result, IsAnd<Success<Session>>((it) => it.get() == _session));
    });

    test('Should return rejection if repository fails saving', () async {
      when(repository.save(_session))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      Try<Session> result = await saveSession(_session);
      expect(result, isA<Rejection<Session>>());
    });
  });
}

class SessionRepositoryMock extends Mock implements SessionRepository {}
