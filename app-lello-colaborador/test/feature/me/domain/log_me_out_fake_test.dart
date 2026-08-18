import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:colaborador/feature/me/domain/repository/me_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out_impl.dart';
import 'package:colaborador/feature/session/domain/repository/session_repository.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

class _FakeAccessTokenRepo extends Fake implements AccessTokenRepository {
  bool cleared = false;

  @override
  Future<Try<Nothing>> clear() async {
    cleared = true;
    return Success(Nothing());
  }
}

class _FakeSessionRepo extends Fake implements SessionRepository {
  bool cleared = false;

  @override
  Future<Try<Nothing>> clear() async {
    cleared = true;
    return Success(Nothing());
  }
}

class _FakeMeRepo extends Fake implements MeRepository {
  bool cleared = false;

  @override
  Future<Try<Nothing>> clear() async {
    cleared = true;
    return Success(Nothing());
  }
}

class _FakeDb extends Fake implements LelloDatabase {
  bool resetCalled = false;

  @override
  Future<Try<Nothing>> resetDb() async {
    resetCalled = true;
    return Success(Nothing());
  }
}

void main() {
  group('LogMeOutImpl', () {
    test('limpa token, sessão, me e banco', () async {
      final access = _FakeAccessTokenRepo();
      final session = _FakeSessionRepo();
      final me = _FakeMeRepo();
      final db = _FakeDb();
      final result = await LogMeOutImpl(
        accessTokenRepository: access,
        sessionRepository: session,
        meRepository: me,
        db: db,
      )();
      expect(result, isA<Success<Nothing>>());
      expect(access.cleared, isTrue);
      expect(session.cleared, isTrue);
      expect(me.cleared, isTrue);
      expect(db.resetCalled, isTrue);
    });
  });
}
