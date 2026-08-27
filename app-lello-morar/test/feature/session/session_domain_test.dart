import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/session/data/data_source/session_local_data_source.dart';
import 'package:morar/feature/session/data/data_source/session_local_data_source_impl.dart';
import 'package:morar/feature/session/data/model/session_model.dart';
import 'package:morar/feature/session/data/repository/session_repository_impl.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/domain/repository/session_repository.dart';
import 'package:morar/feature/session/domain/use_case/load_session/load_session_impl.dart';
import 'package:morar/feature/session/domain/use_case/save_session/save_session_impl.dart';
import 'package:morar/feature/session/presentation/bloc/session_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fixtures.dart';

class _FakeGetMe extends Fake implements GetMe {
  _FakeGetMe({this.remote, this.local, this.failRemote = false});
  final Me? remote;
  final Me? local;
  final bool failRemote;

  @override
  Future<Try<Me?>> call(DataOrigin origin) async {
    if (origin == DataOrigin.remote) {
      if (failRemote) return Rejection(UnknownFailure('remote'));
      return Success(remote);
    }
    return Success(local);
  }
}

class _FakeSessionRepository extends Fake implements SessionRepository {
  _FakeSessionRepository({this.stored, this.fail = false});
  SessionModel? stored;
  final bool fail;
  Session? saved;

  @override
  Future<Try<SessionModel?>> select() async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(stored);
  }

  @override
  Future<Try<SessionModel?>> save(Session session) async {
    if (fail) return Rejection(UnknownFailure('x'));
    saved = session;
    return Success(SessionModel.fromEntity(session));
  }
}

class _ThrowingDataSource extends Fake implements SessionLocalDataSource {
  @override
  Future<SessionModel?> select() async => throw Exception('x');
  @override
  Future<SessionModel?> save(SessionModel? model) async => throw Exception('x');
}

void main() {
  group('SessionModel', () {
    test('round trip json', () {
      final model = SessionModel.fromEntity(testSession())!;
      final json = jsonDecode(jsonEncode(model.toJson()));
      final back = SessionModel.fromJson(json).toEntity();
      expect(back.me!.email, 'ana@lello.com');
      expect(back.condominium!.reference, 'R1');
      expect(back.unity!.title, '101');
      expect(SessionModel.fromEntity(null), isNull);
      expect(SessionModel().toEntity().me, isNull);
    });
  });

  group('SessionLocalDataSourceImpl', () {
    test('save/select/remove usando SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final ds = SessionLocalDataSourceImpl();
      expect(await ds.select(), isNull);
      await ds.save(SessionModel.fromEntity(testSession()));
      final loaded = await ds.select();
      expect(loaded!.me!.name, 'ana silva');
      await ds.save(null);
      expect(await ds.select(), isNull);
    });

    test('conteúdo corrompido devolve null', () async {
      SharedPreferences.setMockInitialValues({'SESSION': '{corrompido'});
      expect(await SessionLocalDataSourceImpl().select(), isNull);
    });
  });

  group('SessionRepositoryImpl', () {
    test('sucesso', () async {
      SharedPreferences.setMockInitialValues({});
      final repo =
          SessionRepositoryImpl(sessionDataSource: SessionLocalDataSourceImpl());
      final saved = await repo.save(testSession());
      expect(saved.fold((_) => null, (m) => m!.unity!.id), 'u1');
      final selected = await repo.select();
      expect(selected.fold((_) => null, (m) => m!.me!.id), 'm1');
      expect((await repo.clear()).fold((_) => null, (_) => 'ok'), 'ok');
      expect((await repo.select()).fold((_) => null, (m) => m), isNull);
    });

    test('falhas viram UnknownFailure', () async {
      final repo = SessionRepositoryImpl(sessionDataSource: _ThrowingDataSource());
      expect((await repo.save(testSession())).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
      expect((await repo.select()).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
      expect((await repo.clear()).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
    });
  });

  group('LoadSessionImpl', () {
    test('remoto com falha rejeita', () async {
      final useCase = LoadSessionImpl(
        getMe: _FakeGetMe(failRemote: true),
        repository: _FakeSessionRepository(),
      );
      final result = await useCase(DataOrigin.remote);
      expect(result.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('sem condomínios ou unidades rejeita com KnownFailure', () async {
      final semCondo = await LoadSessionImpl(
        getMe: _FakeGetMe(remote: testMe(condominiums: [])),
        repository: _FakeSessionRepository(),
      )(DataOrigin.remote);
      expect((semCondo.fold((f) => f, (_) => null) as KnownFailure).code,
          'condominiums_not_found');

      final semUnidade = await LoadSessionImpl(
        getMe: _FakeGetMe(
          remote: testMe(condominiums: [
            testCondominium(blocks: [testBlock(units: [])])
          ]),
        ),
        repository: _FakeSessionRepository(),
      )(DataOrigin.remote);
      expect((semUnidade.fold((f) => f, (_) => null) as KnownFailure).code,
          'units_not_found');
    });

    test('escolhe condomínio e unidade da sessão persistida', () async {
      final me = testMe(condominiums: [
        testCondominium(id: 'c1', reference: 'R1', blocks: [
          testBlock(units: [testUnity(id: 'u1'), testUnity(id: 'u2', title: '102')])
        ]),
        testCondominium(id: 'c2', reference: 'R2', blocks: [
          testBlock(id: 'b2', units: [testUnity(id: 'u3', title: '301')])
        ]),
      ]);
      final stored = Session()
        ..me = me
        ..condominium = me.condominiums![1]
        ..unity = me.condominiums![1].blocks!.first.units!.first;
      final result = await LoadSessionImpl(
        getMe: _FakeGetMe(remote: me),
        repository: _FakeSessionRepository(stored: SessionModel.fromEntity(stored)),
      )(DataOrigin.remote);
      final session = result.fold((_) => null, (s) => s)!;
      expect(session.condominium!.id, 'c2');
      expect(session.unity!.id, 'u3');
    });

    test('sessão persistida desconhecida cai no primeiro', () async {
      final me = testMe();
      final stored = Session()
        ..me = me
        ..condominium = Condominium(id: 'zzz', reference: 'ZZ')
        ..unity = testUnity(id: 'nope');
      final result = await LoadSessionImpl(
        getMe: _FakeGetMe(remote: me),
        repository: _FakeSessionRepository(stored: SessionModel.fromEntity(stored)),
      )(DataOrigin.remote);
      final session = result.fold((_) => null, (s) => s)!;
      expect(session.condominium!.id, 'c1');
      expect(session.unity!.id, 'u1');
    });

    test('origem local com falha no repositório devolve só o me', () async {
      final result = await LoadSessionImpl(
        getMe: _FakeGetMe(local: testMe(name: 'local')),
        repository: _FakeSessionRepository(fail: true),
      )(DataOrigin.local);
      final session = result.fold((_) => null, (s) => s)!;
      expect(session.me!.name, 'local');
      expect(session.condominium!.id, 'c1');
    });
  });

  test('SaveSessionImpl', () async {
    final repo = _FakeSessionRepository();
    final session = testSession();
    final result = await SaveSessionImpl(repository: repo)(session);
    expect(result.fold((_) => null, (s) => s), same(session));
    expect(repo.saved, same(session));

    final failed = await SaveSessionImpl(repository: _FakeSessionRepository(fail: true))(session);
    expect(failed.fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('estados e eventos são comparáveis', () {
    final session = testSession();
    expect(SessionLoadedState(session), SessionLoadedState(session));
    expect(SessionLoadedState(session, switchFailed: true).props,
        [session, true]);
    expect(SessionLoadingState(session).props, [session]);
    expect(SessionFailedState(UnknownFailure('x'), null).props,
        [UnknownFailure('x'), null]);
    expect(const SessionInitialState().session, isNull);
    expect(const SessionLoadEvent(onLogin: true).props, [true]);
    expect(SessionSelectUnityEvent(testUnity()).props.single, isA<Object>());
    expect(SessionSelectCondominiumEvent(testCondominium()).props, hasLength(1));
    expect(SessionUpdateMeEvent(null).props, [null]);
    expect(SessionLogoutEvent(null, true).props, [null, true]);
    expect(const SessionEmptyEvent().props, isEmpty);
  });
}
