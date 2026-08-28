import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/init_sqflite_ffi.dart';

DigitalPointTableCompanion _point({
  String meId = 'm1',
  String condominiumId = 'c1',
  DateTime? date,
  String status = 'pending',
  String uniqueHash = 'h1',
}) =>
    DigitalPointTableCompanion.insert(
      meId: meId,
      condominiumId: condominiumId,
      date: date ?? DateTime(2026, 1, 10, 8),
      latitude: '-23.5',
      longitude: '-46.6',
      typePoint: 'offline',
      photoPath: 'foto.jpg',
      status: status,
      captureType: 'manual',
      uniqueHash: uniqueHash,
      reference: const Value('R1'),
      numCad: const Value('10'),
      numCra: const Value('20'),
    );

DigitalPointLogTableCompanion _log({int digitalPointId = 1}) =>
    DigitalPointLogTableCompanion.insert(
      digitalPointId: digitalPointId,
      date: DateTime(2026, 1, 10, 9),
      statusPrevious: 'pending',
      statusNew: 'sent',
      description: 'sincronizado',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  late DigitalPointDatabase database;

  setUp(() async {
    database = DigitalPointDatabase();
    await database.resetDb();
  });

  tearDown(() async {
    await database.close();
  });

  group('DigitalPointDao', () {
    test('guarda e lista os pontos do colaborador no condomínio', () async {
      await database.digitalPointDao.insert(_point());
      await database.digitalPointDao.insert(
        _point(date: DateTime(2026, 1, 10, 17), uniqueHash: 'h2'),
      );
      await database.digitalPointDao.insert(
        _point(meId: 'outro', uniqueHash: 'h3'),
      );

      final list = await database.digitalPointDao.listAll('c1', 'm1');

      expect(list, hasLength(2));
      expect(list.first.photoPath, 'foto.jpg');
      expect(list.first.reference, 'R1');
      expect(list.first.tabletSession, isFalse);
    });

    test('filtra os pontos por status', () async {
      await database.digitalPointDao.insert(_point());
      await database.digitalPointDao.insert(
        _point(status: 'sent', uniqueHash: 'h2', date: DateTime(2026, 1, 11)),
      );

      final pendentes =
          await database.digitalPointDao.listByStatus('c1', 'm1', 'pending');
      final enviados =
          await database.digitalPointDao.listByStatus('c1', 'm1', 'sent');

      expect(pendentes, hasLength(1));
      expect(enviados, hasLength(1));
      expect(enviados.single.status, 'sent');
    });

    test('lista os pendentes do aparelho independente do colaborador',
        () async {
      await database.digitalPointDao.insert(_point());
      await database.digitalPointDao.insert(
        _point(meId: 'm2', condominiumId: 'c2', uniqueHash: 'h2'),
      );
      await database.digitalPointDao.insert(
        _point(status: 'sent', uniqueHash: 'h3', date: DateTime(2026, 1, 12)),
      );

      final pendentes =
          await database.digitalPointDao.listPendingFromDevice();

      expect(pendentes, hasLength(2));
    });

    test('busca um ponto pela data', () async {
      final date = DateTime(2026, 1, 10, 8);
      await database.digitalPointDao.insert(_point(date: date));

      final found = await database.digitalPointDao.getSingle('c1', 'm1', date);
      final missing = await database.digitalPointDao
          .getSingle('c1', 'm1', DateTime(2026, 2, 1));

      expect(found?.uniqueHash, 'h1');
      expect(missing, isNull);
    });

    test('atualiza o status de um ponto', () async {
      await database.digitalPointDao.insert(_point());
      final stored = (await database.digitalPointDao.listAll('c1', 'm1')).single;

      await database.digitalPointDao.updatePointStatus(
        id: stored.id,
        newStatusEnum: DigitalPointStatusEnum.sended,
      );

      final updated = (await database.digitalPointDao.listAll('c1', 'm1')).single;
      expect(updated.status, 'sended');
    });

    test('clear apaga os pontos guardados', () async {
      await database.digitalPointDao.insert(_point());

      final removed = await database.digitalPointDao.clear();

      expect(removed, 1);
      expect(await database.digitalPointDao.listAll('c1', 'm1'), isEmpty);
    });
  });

  group('DigitalPointLogDao', () {
    test('guarda o histórico de cada ponto', () async {
      await database.digitalPointLogDao.insert(_log());
      await database.digitalPointLogDao.insert(_log(digitalPointId: 2));

      final list = await database.digitalPointLogDao.list(1);

      expect(list, hasLength(1));
      expect(list.single.statusNew, 'sent');
      expect(list.single.description, 'sincronizado');
    });

    test('clear apaga o histórico', () async {
      await database.digitalPointLogDao.insert(_log());

      final removed = await database.digitalPointLogDao.clear();

      expect(removed, 1);
      expect(await database.digitalPointLogDao.list(1), isEmpty);
    });
  });

  group('resetDb', () {
    test('limpa pontos e histórico', () async {
      await database.digitalPointDao.insert(_point());
      await database.digitalPointLogDao.insert(_log());

      await database.resetDb();

      expect(await database.digitalPointDao.listAll('c1', 'm1'), isEmpty);
      expect(await database.digitalPointLogDao.list(1), isEmpty);
    });
  });

  group('migration', () {
    test('onCreate cria todas as tabelas', () async {
      await database.migration.onCreate(database.createMigrator());

      expect(database.allTables, isNotEmpty);
      expect(await database.digitalPointDao.listAll('c1', 'm1'), isEmpty);
    });

    test('onUpgrade para a versão 6 mantém o banco utilizável', () async {
      await database.migration.onUpgrade(database.createMigrator(), 5, 6);

      expect(await database.digitalPointDao.listAll('c1', 'm1'), isEmpty);
    });

    test('onUpgrade para a versão 7 mantém o banco utilizável', () async {
      await database.migration.onUpgrade(database.createMigrator(), 6, 7);

      expect(await database.digitalPointDao.listAll('c1', 'm1'), isEmpty);
    });

    test('onUpgrade sem regra correspondente não altera nada', () async {
      await database.digitalPointDao.insert(_point());

      await database.migration.onUpgrade(database.createMigrator(), 1, 5);

      expect(await database.digitalPointDao.listAll('c1', 'm1'), hasLength(1));
    });
  });
}
