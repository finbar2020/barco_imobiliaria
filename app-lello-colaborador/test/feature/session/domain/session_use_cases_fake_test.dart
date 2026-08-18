import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:colaborador/feature/session/data/data_source/session_local_data_source.dart';
import 'package:colaborador/feature/session/data/model/session_model.dart';
import 'package:colaborador/feature/session/data/repository/session_repository_impl.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/domain/repository/session_repository.dart';
import 'package:colaborador/feature/session/domain/use_case/load_session/load_session_impl.dart';
import 'package:colaborador/feature/session/domain/use_case/save_session/save_session_impl.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull, equals;
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

class _FakeGetMe extends Fake implements GetMe {
  _FakeGetMe(this.result);
  Try<Me?> result;

  @override
  Future<Try<Me?>> call(DataOrigin params) async => result;
}

class _FakeSessionRepo extends Fake implements SessionRepository {
  Session? saved;
  Try<SessionModel?> selectResult = Success(null);
  Try<SessionModel?> saveResult = Success(null);

  @override
  Future<Try<SessionModel?>> select() async => selectResult;

  @override
  Future<Try<SessionModel?>> save(Session? session) async {
    saved = session;
    return saveResult;
  }
}

class _FakeLocal extends Fake implements SessionLocalDataSource {
  SessionModel? stored;

  @override
  Future<SessionModel?> select() async => stored;

  @override
  Future<SessionModel?> save(SessionModel? model) async {
    stored = model;
    return model;
  }
}

void main() {
  group('LoadSessionImpl', () {
    test('rejeita me remoto com erro', () async {
      final result = await LoadSessionImpl(
        getMe: _FakeGetMe(Rejection(UnknownFailure('x'))),
        repository: _FakeSessionRepo(),
      )(DataOrigin.remote);
      expect(result, isA<Rejection<Session>>());
    });

    test('rejeita me nulo', () async {
      final result = await LoadSessionImpl(
        getMe: _FakeGetMe(Success(null)),
        repository: _FakeSessionRepo(),
      )(DataOrigin.local);
      expect(result, isA<Rejection<Session>>());
    });

    test('rejeita me sem condomínio', () async {
      final result = await LoadSessionImpl(
        getMe: _FakeGetMe(Success(Me(id: '1'))),
        repository: _FakeSessionRepo(),
      )(DataOrigin.local);
      expect(result, isA<Rejection<Session>>());
    });

    test('carrega sessão com o primeiro condomínio', () async {
      final result = await LoadSessionImpl(
        getMe: _FakeGetMe(Success(testMe())),
        repository: _FakeSessionRepo(),
      )(DataOrigin.local);
      expect(result, isA<Success<Session>>());
      expect((result as Success<Session>).get().condominium.id, 'c1');
      expect(result.get().userId, 'm1');
    });
  });

  group('SaveSessionImpl', () {
    test('devolve a sessão original em sucesso', () async {
      final repo = _FakeSessionRepo();
      final session = testSession();
      final result = await SaveSessionImpl(repository: repo)(session);
      expect(result, isA<Success<Session?>>());
      expect(repo.saved, session);
      expect((result as Success<Session?>).get(), session);
    });

    test('propaga rejection', () async {
      final repo = _FakeSessionRepo()
        ..saveResult = Rejection(UnknownFailure('x'));
      final result = await SaveSessionImpl(repository: repo)(testSession());
      expect(result, isA<Rejection<Session?>>());
    });
  });

  group('SessionRepositoryImpl', () {
    test('select e save usam o data source', () async {
      final local = _FakeLocal();
      final repo = SessionRepositoryImpl(sessionDataSource: local);
      final select = await repo.select();
      expect(select, isA<Success<SessionModel?>>());
      final saved = await repo.save(testSession());
      expect(saved, isA<Success<SessionModel?>>());
      expect(local.stored, isNotNull);
      final cleared = await repo.clear();
      expect(cleared, isA<Success<Nothing>>());
      expect(local.stored, isNull);
    });
  });

  group('Session', () {
    test('expõe ids da sessão compartilhada', () {
      final session = testSession();
      expect(session.condominiumId, 'c1');
      expect(session.condominiumReference, 'R1');
      expect(session.userId, 'm1');
      expect(session.unitId, '');
    });
  });
}
