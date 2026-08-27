import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/core/database/lello_database.dart';
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:morar/feature/me/data/data_source/local/me_local_data_source_impl.dart';
import 'package:morar/feature/me/data/data_source/remote/me_api.dart';
import 'package:morar/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:morar/feature/me/data/data_source/remote/me_remote_data_source_impl.dart';
import 'package:morar/feature/me/data/model/me_model.dart';
import 'package:morar/feature/me/data/model/me_password_model.dart';
import 'package:morar/feature/me/data/repository/me_repository_impl.dart';
import 'package:morar/feature/me/data/repository/profile_picture_repository_impl.dart';
import 'package:morar/feature/me/domain/use_case/log_me_out/log_me_out_impl.dart';
import 'package:morar/feature/session/domain/repository/session_repository.dart';
import 'package:morar/feature/session/data/model/session_model.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/me/domain/repository/me_repository.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/init_sqflite_ffi.dart';

class MockMeApi extends Mock implements MeApi {}

class _FakeLocal extends Fake implements MeLocalDataSource {
  MeModel? stored;
  bool fail = false;

  @override
  Future<MeModel?> select() async {
    if (fail) throw Exception('local');
    return stored;
  }

  @override
  Future<MeModel?> save(MeModel? model) async {
    if (fail) throw Exception('local');
    stored = model;
    return model;
  }
}

class _FakeRemote extends Fake implements MeRemoteDataSource {
  _FakeRemote({this.fail = false});
  final bool fail;
  MePasswordModel? password;

  @override
  Future<MeModel> get() async {
    if (fail) throw Exception('remote');
    return MeModel.fromEntity(testMe(name: 'remoto'))!;
  }

  @override
  Future<MeModel> patch(MeModel me, String code) async {
    if (fail) throw Exception('remote');
    return me..name = '${me.name}-$code';
  }

  @override
  Future updatePassword(MePasswordModel model) async {
    if (fail) throw Exception('remote');
    password = model;
  }
}

class _FakeUploader extends Fake implements Uploader {
  _FakeUploader({this.throws = false});
  final bool throws;
  String? path;

  @override
  Future<String> upload(String path, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    if (throws) throw Exception('x');
    this.path = path;
    onComplete('ok');
    return 'task-1';
  }
}

class _FakeAccessTokenRepository extends Fake implements AccessTokenRepository {
  int cleared = 0;
  @override
  Future<Try<Nothing>> clear() async {
    cleared++;
    return Success(Nothing());
  }
}

class _FakeSessionRepository extends Fake implements SessionRepository {
  int cleared = 0;
  @override
  Future<Try<Nothing>> clear() async {
    cleared++;
    return Success(Nothing());
  }
}

class _FakeMeRepository extends Fake implements MeRepository {
  int cleared = 0;
  @override
  Future<Try<Nothing>> clear() async {
    cleared++;
    return Success(Nothing());
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
    initSqfliteForTests();
  });

  group('MeLocalDataSourceImpl (drift)', () {
    late LelloDatabase db;
    late MeLocalDataSourceImpl dataSource;

    setUp(() {
      db = LelloDatabase();
      dataSource = MeLocalDataSourceImpl(
        meDao: db.meDao,
        condoDao: db.condominiumDao,
        blockDao: db.blockDao,
        unitDao: db.unitDao,
        layoutDao: db.layoutDao,
      );
    });

    tearDown(() => db.close());

    test('save + select reconstroem o usuário com condomínios e layout',
        () async {
      final me = testMe(
        condominiums: [
          testCondominium(
            blocks: [
              testBlock(units: [testUnity(), testUnity(id: 'u2', title: '102')]),
              testBlock(id: 'b2', name: 'Bloco B', units: [testUnity(id: 'u3')]),
            ],
            layout: testLayout(),
          ),
          testCondominium(id: 'c2', reference: 'R2', blocks: [], layout: testLayout()),
        ],
      );
      final saved = await dataSource.save(MeModel.fromEntity(me));
      expect(saved, isNotNull);

      final loaded = (await dataSource.select())!;
      expect(loaded.email, 'ana@lello.com');
      expect(loaded.cpf, '12345678901');
      expect(loaded.lastUpdatedAt, isNotNull);
      expect(loaded.condominiums!.length, 2);
      final c1 = loaded.condominiums!.firstWhere((c) => c!.id == 'c1')!;
      expect(c1.layout!.name, 'Lello');
      expect(c1.blocks!.length, 2);
      final b1 = c1.blocks!.firstWhere((b) => b!.id == 'b1')!;
      expect(b1.units!.map((u) => u.id), containsAll(['u1', 'u2']));
      expect(b1.units!.firstWhere((u) => u.id == 'u1').notificationContext,
          'ctx-u1');
      final c2 = loaded.condominiums!.firstWhere((c) => c!.id == 'c2')!;
      expect(c2.blocks, isEmpty);
    });

    test('condomínio sem layout mantém layout nulo quando outro tem layout',
        () async {
      // Corrigido: `select()` não faz mais `.toList().first` por condomínio;
      // o condomínio sem layout salvo fica com `layout == null` em vez de
      // estourar `StateError`.
      await dataSource.save(MeModel.fromEntity(testMe(condominiums: [
        testCondominium(id: 'c1', layout: testLayout()),
        testCondominium(id: 'c2', reference: 'R2'),
      ])));
      final loaded = (await dataSource.select())!;
      expect(loaded.condominiums!.length, 2);
      final c1 = loaded.condominiums!.firstWhere((c) => c!.id == 'c1')!;
      expect(c1.layout!.name, 'Lello');
      final c2 = loaded.condominiums!.firstWhere((c) => c!.id == 'c2')!;
      expect(c2.layout, isNull);
    });

    test('save(null) limpa as tabelas', () async {
      await dataSource.save(MeModel.fromEntity(testMe()));
      expect(await dataSource.select(), isNotNull);
      expect(await dataSource.save(null), isNull);
      expect(await dataSource.select(), isNull);
      expect(await db.condominiumDao.list(), isEmpty);
      expect(await db.unitDao.list(), isEmpty);
    });
  });

  group('MeRemoteDataSourceImpl', () {
    late MockMeApi api;
    late MeRemoteDataSourceImpl dataSource;

    setUpAll(() {
      registerFallbackValue(MeModel());
      registerFallbackValue(MePasswordModel());
    });

    setUp(() {
      api = MockMeApi();
      dataSource = MeRemoteDataSourceImpl(api: api, idEmpresa: 7);
    });

    test('get formata o cpf e marca a atualização', () async {
      when(() => api.get(7)).thenAnswer(
        (_) async => Response<dynamic>(
          http.Response(jsonEncode({'name': 'n', 'cpf': '12345678901'}), 200),
          null,
        ),
      );
      final me = await dataSource.get();
      expect(me.cpf, '123.456.789-01');
      expect(me.lastUpdatedAt, isNotNull);
    });

    test('patch e updatePassword', () async {
      when(() => api.patch(any(), 'code')).thenAnswer(
        (_) async => Response<dynamic>(
          http.Response(jsonEncode({'name': 'p', 'cpf': '00000000000'}), 200),
          null,
        ),
      );
      when(() => api.updatePassword(any())).thenAnswer(
        (_) async => Response<dynamic>(http.Response('{}', 200), null),
      );
      final me = await dataSource.patch(MeModel(), 'code');
      expect(me.name, 'p');
      expect(me.cpf, '000.000.000-00');
      expect(await dataSource.updatePassword(MePasswordModel()), isNull);

      when(() => api.get(7)).thenAnswer(
        (_) async => Response<dynamic>(http.Response('', 500), null, error: 'e'),
      );
      expect(dataSource.get(), throwsA('e'));
    });
  });

  group('MeRepositoryImpl', () {
    late _FakeLocal local;

    setUp(() => local = _FakeLocal());

    MeRepositoryImpl build({bool failRemote = false}) => MeRepositoryImpl(
          localDataSource: local,
          remoteDataSource: _FakeRemote(fail: failRemote),
          baseUrl: 'http://x',
        );

    test('select busca remoto e salva no cache', () async {
      final result = await build().select();
      expect(result.fold((_) => null, (m) => m!.name), 'remoto');
      expect(local.stored!.name, 'remoto');
    });

    test('select falha vira UnknownFailure', () async {
      final result = await build(failRemote: true).select();
      expect(result.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('save envia patch e persiste', () async {
      final result = await build().save(testMe(name: 'a'), 'k');
      expect(result.fold((_) => null, (m) => m!.name), 'a-k');
      expect(local.stored!.name, 'a-k');
      final failed = await build(failRemote: true).save(testMe(), 'k');
      expect(failed.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('updatePassword monta o modelo', () async {
      final remote = _FakeRemote();
      final repo = MeRepositoryImpl(
        localDataSource: local,
        remoteDataSource: remote,
        baseUrl: 'x',
      );
      final result = await repo.updatePassword('12345678901', 'antiga', 'nova');
      expect(result.fold((_) => null, (r) => 'ok'), 'ok');
      expect(remote.password!.cpf, '12345678901');
      // Corrigido: `MePasswordModel.init` recebe (cpf, originPassword,
      // password) e os campos chegam na ordem certa na API.
      expect(remote.password!.originPassword, 'antiga');
      expect(remote.password!.password, 'nova');

      final failed =
          await build(failRemote: true).updatePassword('12345678901', 'a', 'b');
      expect(failed.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('selectFromCache e clear', () async {
      local.stored = MeModel.fromEntity(testMe(name: 'cache'));
      expect((await build().selectFromCache()).fold((_) => null, (m) => m!.name),
          'cache');
      expect((await build().clear()).fold((_) => null, (_) => 'ok'), 'ok');
      expect(local.stored, isNull);

      local.fail = true;
      expect((await build().selectFromCache()).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
      expect((await build().clear()).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
    });
  });

  test('ProfilePictureRepositoryImpl delega ao uploader', () async {
    final uploader = _FakeUploader();
    final repo = ProfilePictureRepositoryImpl(uploader: uploader);
    var completed = '';
    final result = await repo.upload(File('f'),
        onComplete: (v) => completed = v, onError: (_) {});
    expect(result.fold((_) => null, (t) => t), 'task-1');
    expect(uploader.path, 'me/pictures');
    expect(completed, 'ok');

    final failed = await ProfilePictureRepositoryImpl(
            uploader: _FakeUploader(throws: true))
        .upload(File('f'), onComplete: (_) {}, onError: (_) {});
    expect(failed.fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('LogMeOutImpl limpa tudo', () async {
    final db = LelloDatabase();
    addTearDown(db.close);
    await db.meDao.insert(MeTableCompanion.insert(
      name: 'n',
      email: 'e',
      picture: '',
      updated: DateTime(2026),
    ));
    final tokens = _FakeAccessTokenRepository();
    final sessions = _FakeSessionRepository();
    final mes = _FakeMeRepository();
    final useCase = LogMeOutImpl(
      accessTokenRepository: tokens,
      sessionRepository: sessions,
      meRepository: mes,
      db: db,
    );
    final result = await useCase();
    expect(result.fold((_) => null, (_) => 'ok'), 'ok');
    expect(tokens.cleared, 1);
    expect(sessions.cleared, 1);
    expect(mes.cleared, 1);
    expect(await db.meDao.get(), isNull);
  });

  test('SessionModel mantém a sessão', () {
    final model = SessionModel.fromEntity(testSession())!;
    final session = model.toEntity();
    expect(session.me!.name, 'ana silva');
    expect(session.unity!.id, 'u1');
    expect(session, isA<Session>());
    expect(Me.empty().name, '');
  });
}
