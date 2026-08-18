import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';
import 'package:lello/feature/me/domain/use_case/log_me_out/log_me_out_impl.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:shared_features/shared_features.dart';

class _FakeTokenRepo extends Fake implements AccessTokenRepository {
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
  bool reset = false;

  @override
  Future<Try<Nothing>> resetDb() async {
    reset = true;
    return Success(Nothing());
  }
}

void main() {
  test('encerra a sessão limpando token, perfil e banco local', () async {
    final tokens = _FakeTokenRepo();
    final session = _FakeSessionRepo();
    final me = _FakeMeRepo();
    final db = _FakeDb();

    final result = await LogMeOutImpl(
      accessTokenRepository: tokens,
      sessionRepository: session,
      meRepository: me,
      db: db,
    )();

    expect(result, isA<Success<Nothing>>());
    expect(tokens.cleared, isTrue);
    expect(session.cleared, isTrue);
    expect(me.cleared, isTrue);
    expect(db.reset, isTrue);
  });
}
