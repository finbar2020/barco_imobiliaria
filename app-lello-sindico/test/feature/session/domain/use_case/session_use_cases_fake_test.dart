import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:lello/feature/session/data/model/session_model.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/domain/repository/session_repository.dart';
import 'package:lello/feature/session/domain/use_case/load_session/load_session_impl.dart';
import 'package:lello/feature/session/domain/use_case/save_session/save_session_impl.dart';

class _FakeSessionRepo extends Fake implements SessionRepository {
  SessionModel? stored;
  bool failSave = false;

  @override
  Future<Try<SessionModel?>> select() async => Success(stored);

  @override
  Future<Try<SessionModel?>> save(Session session) async {
    if (failSave) return Rejection(UnknownFailure('boom'));
    stored = SessionModel.fromEntity(session);
    return Success(stored);
  }
}

class _FakeGetMe extends Fake implements GetMe {
  Me? me;
  bool failRemote = false;

  @override
  Future<Try<Me?>> call(DataOrigin origin) async {
    if (failRemote && origin == DataOrigin.remote) {
      return Rejection(UnknownFailure('offline'));
    }
    return Success(me);
  }
}

void main() {
  late _FakeSessionRepo repo;
  late _FakeGetMe getMe;

  setUp(() {
    repo = _FakeSessionRepo();
    getMe = _FakeGetMe();
  });

  group('SaveSessionImpl', () {
    test('salva e devolve a session', () async {
      final session = Session()
        ..selectedCondominium = const Condominium(id: '1', reference: 'ref-1');
      final result = await SaveSessionImpl(repository: repo)(session);
      expect(result, isA<Success<Session>>());
      expect(repo.stored?.selectedCondominium, 'ref-1');
    });

    test('propaga erro do repositório', () async {
      repo.failSave = true;
      final result = await SaveSessionImpl(repository: repo)(Session());
      expect(result, isA<Rejection<Session>>());
    });
  });

  group('LoadSessionImpl', () {
    test('monta session com o condomínio persistido', () async {
      getMe.me = Me(condominiums: const [
        Condominium(id: '1', reference: 'a'),
        Condominium(id: '2', reference: 'b'),
      ]);
      repo.stored = SessionModel()..selectedCondominium = 'b';

      final result =
          await LoadSessionImpl(getMe: getMe, repository: repo)(DataOrigin.local);
      expect(result, isA<Success<Session>>());
      expect((result as Success<Session>).get().selectedCondominium?.reference, 'b');
    });

    test('rejeita quando não há condomínios', () async {
      getMe.me = Me(condominiums: const []);
      repo.stored = SessionModel()..selectedCondominium = 'x';
      final result =
          await LoadSessionImpl(getMe: getMe, repository: repo)(DataOrigin.local);
      expect(result, isA<Rejection<Session>>());
    });

    test('rejeita falha remota do GetMe', () async {
      getMe.failRemote = true;
      final result =
          await LoadSessionImpl(getMe: getMe, repository: repo)(DataOrigin.remote);
      expect(result, isA<Rejection<Session>>());
    });
  });

  test('SessionModel fromJson/toJson/fromEntity', () {
    final model = SessionModel.fromJson({'selected_condominium': 'ref-1'});
    expect(model.selectedCondominium, 'ref-1');
    expect(model.toJson()['selected_condominium'], 'ref-1');
    final fromEntity = SessionModel.fromEntity(
      Session()..selectedCondominium = const Condominium(id: '1', reference: 'r'),
    );
    expect(fromEntity?.selectedCondominium, 'r');
    expect(SessionModel.fromEntity(null) == null, isTrue);
  });
}
