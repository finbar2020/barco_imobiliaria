import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/database/documents/cached_documents_dao.dart';
import 'package:morar/core/database/lello_database.dart';

import '../../helpers/init_sqflite_ffi.dart';

MeTableCompanion _me({String email = 'ana@lello.com'}) => MeTableCompanion.insert(
      id: const Value('m1'),
      name: 'Ana',
      email: email,
      cpf: const Value('123'),
      phone: const Value('11'),
      picture: '',
      pictureHash: const Value('h'),
      biometricPictureHash: const Value('b'),
      useFacialBiometric: const Value(true),
      updated: DateTime(2026, 1, 10),
    );

void main() {
  initSqfliteForTests();

  late LelloDatabase db;

  setUp(() async {
    db = LelloDatabase();
    await db.resetDb();
  });

  tearDown(() => db.close());

  test('schema e mixins dos DAOs', () {
    expect(db.schemaVersion, 14);
    expect(db.meDao.meTable, db.meTable);
    expect(db.condominiumDao.condominiumTable, db.condominiumTable);
    expect(db.blockDao.blockTable, db.blockTable);
    expect(db.unitDao.unitTable, db.unitTable);
    expect(db.authorizationDao.authorizationTable, db.authorizationTable);
    expect(db.layoutDao.layoutTable, db.layoutTable);
    expect(db.cachedDocumentsDao.cachedDocumentsTable, db.cachedDocumentsTable);
    expect(db.allTables, hasLength(7));
  });

  test('MeDao substitui pela chave (email)', () async {
    expect(await db.meDao.get(), isNull);
    await db.meDao.insert(_me());
    await db.meDao.insert(_me()..copyWith(name: const Value('Bia')));
    final me = (await db.meDao.get())!;
    expect(me.email, 'ana@lello.com');
    expect(me.useFacialBiometric, isTrue);
    expect(await db.meDao.clear(), 1);
    expect(await db.meDao.get(), isNull);
  });

  test('CondominiumDao, BlockDao, UnitDao e LayoutDao', () async {
    await db.condominiumDao.insert(CondominiumTableCompanion.insert(
      id: 'c1',
      reference: const Value('R1'),
      regulationUrl: 'http://r',
      active_manager: const Value(true),
    ));
    await db.condominiumDao.insert(CondominiumTableCompanion.insert(
      id: 'c1',
      name: const Value('Novo'),
      regulationUrl: 'http://r2',
    ));
    final condos = await db.condominiumDao.list();
    expect(condos, hasLength(1));
    expect(condos.single.name, 'Novo');
    expect(condos.single.reference, isNull);

    await db.blockDao.insert(BlockTableCompanion.insert(id: 'b1', condominiumId: 'c1', name: const Value('A')));
    expect((await db.blockDao.list()).single.name, 'A');

    await db.unitDao.insert(UnitTableCompanion.insert(id: 'u1', blockId: 'b1', title: const Value('101')));
    final unit = (await db.unitDao.list()).single;
    expect(unit.notificationContext, '');
    expect(unit.rented, isNull);

    await db.layoutDao.insert(LayoutTableCompanion.insert(id: 'l1', condoId: 'c1', primary: const Value('#fff')));
    expect((await db.layoutDao.list()).single.primary, '#fff');

    expect(await db.condominiumDao.clear(), 1);
    expect(await db.blockDao.clear(), 1);
    expect(await db.unitDao.clear(), 1);
    expect(await db.layoutDao.clear(), 1);
  });

  test('AuthorizationDao guarda uma única role', () async {
    await db.authorizationDao.insert(const AuthorizationTableCompanion(role: Value('morar.owner')));
    expect((await db.authorizationDao.get()).role, 'morar.owner');
    expect(await db.authorizationDao.clear(), 1);
    expect(db.authorizationDao.get(), throwsStateError);
  });

  test('CachedDocumentsDao', () async {
    expect(CachedDocumentsDao.ttl, const Duration(hours: 24));
    expect(await db.cachedDocumentsDao.read('c', 'u', 'atas'), isNull);
    final now = DateTime(2026, 3, 1, 12);
    await db.cachedDocumentsDao.upsert('c', 'u', 'atas', '[1]', now);
    await db.cachedDocumentsDao.upsert('c', 'u', 'atas', '[2]', now.add(const Duration(hours: 1)));
    final cached = (await db.cachedDocumentsDao.read('c', 'u', 'atas'))!;
    expect(cached.documentsJson, '[2]');
    expect(cached.lastFetchedAt, now.add(const Duration(hours: 1)).millisecondsSinceEpoch);
    expect(cached.lastErrorAt, isNull);

    await db.cachedDocumentsDao.markFailed('c', 'u', 'atas', now.add(const Duration(hours: 2)));
    expect((await db.cachedDocumentsDao.read('c', 'u', 'atas'))!.lastErrorAt,
        now.add(const Duration(hours: 2)).millisecondsSinceEpoch);
    expect(await db.cachedDocumentsDao.clear(), 1);
  });

  test('resetDb esvazia todas as tabelas', () async {
    await db.meDao.insert(_me());
    await db.authorizationDao.insert(const AuthorizationTableCompanion(role: Value('r')));
    final result = await db.resetDb();
    expect(result.fold((_) => 'erro', (_) => 'ok'), 'ok');
    expect(await db.meDao.get(), isNull);
    expect(await db.select(db.authorizationTable).get(), isEmpty);
  });

  test('migração recria o banco quando um passo falha', () async {
    await db.meDao.insert(_me());
    final migrator = db.createMigrator();
    // As colunas já existem: o `addColumn` falha e o fallback recria tudo.
    for (final from in [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12]) {
      await db.migration.onUpgrade(migrator, from, 14);
      expect(await db.meDao.get(), isNull, reason: 'from $from');
      await db.meDao.insert(_me());
    }
    // De 13 para 14 só cria a tabela de documentos (idempotente).
    await db.migration.onUpgrade(migrator, 13, 14);
    expect(await db.meDao.get(), isNotNull);
    await db.migration.onUpgrade(migrator, 10, 14);
    expect(await db.meDao.get(), isNotNull);
    await db.migration.onCreate(migrator);
  });
}
