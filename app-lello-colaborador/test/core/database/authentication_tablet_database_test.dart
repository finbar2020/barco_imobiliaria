import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/init_sqflite_ffi.dart';

CondominiumInfoTableCompanion _condoInfo({
  String condoCode = 'ABC123',
  String reference = 'R1',
}) =>
    CondominiumInfoTableCompanion.insert(
      condoCode: condoCode,
      reference: reference,
      name: 'Torre Lello',
      picturehash: 'hash',
      status: 'active',
      ref: 'ref1',
    );

EmployeeInfoTableCompanion _employeeInfo({
  String condoCode = 'ABC123',
  String cpf = '12345678901',
  String name = 'Ana Silva',
}) =>
    EmployeeInfoTableCompanion.insert(
      condoCode: condoCode,
      numCad: '10',
      numCra: '20',
      cpf: cpf,
      name: name,
      jobPosition: 'porteiro',
      idLogin: 'l1',
      pictureHash: '',
      registered: true,
      status: 'APPROVED',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  late AuthenticationTabletDatabase database;

  setUp(() async {
    database = AuthenticationTabletDatabase();
    await database.resetDb();
  });

  tearDown(() async {
    await database.close();
  });

  group('CondominiumInfoDao', () {
    test('guarda e devolve o condomínio pelo código', () async {
      await database.condominiumInfoDao.insert(_condoInfo());

      final found = await database.condominiumInfoDao.get('ABC123');
      final missing = await database.condominiumInfoDao.get('ZZZ999');

      expect(found?.name, 'Torre Lello');
      expect(found?.ref, 'ref1');
      expect(missing, isNull);
    });

    test('regravar a mesma referência substitui os dados', () async {
      await database.condominiumInfoDao.insert(_condoInfo());
      await database.condominiumInfoDao.insert(
        _condoInfo(condoCode: 'NOVO123'),
      );

      expect(await database.condominiumInfoDao.get('ABC123'), isNull);
      expect(await database.condominiumInfoDao.get('NOVO123'), isNotNull);
    });

    test('clear apaga o condomínio guardado', () async {
      await database.condominiumInfoDao.insert(_condoInfo());

      final removed = await database.condominiumInfoDao.clear();

      expect(removed, 1);
      expect(await database.condominiumInfoDao.get('ABC123'), isNull);
    });
  });

  group('EmployeeInfoDao', () {
    test('lista os colaboradores do código do condomínio', () async {
      await database.employeeInfoDao.insert(_employeeInfo());
      await database.employeeInfoDao.insert(
        _employeeInfo(cpf: '98765432100', name: 'Bruno Souza'),
      );
      await database.employeeInfoDao.insert(
        _employeeInfo(condoCode: 'OUTRO', cpf: '11122233344'),
      );

      final list = await database.employeeInfoDao.get('ABC123');

      expect(list, hasLength(2));
      expect(list.map((e) => e.name), contains('Bruno Souza'));
      expect(list.first.registered, isTrue);
      expect(list.first.jobPosition, 'porteiro');
    });

    test('regravar o mesmo cpf substitui os dados', () async {
      await database.employeeInfoDao.insert(_employeeInfo());
      await database.employeeInfoDao.insert(
        _employeeInfo(name: 'Ana Atualizada'),
      );

      final list = await database.employeeInfoDao.get('ABC123');

      expect(list, hasLength(1));
      expect(list.single.name, 'Ana Atualizada');
    });

    test('clear apaga os colaboradores', () async {
      await database.employeeInfoDao.insert(_employeeInfo());

      final removed = await database.employeeInfoDao.clear();

      expect(removed, 1);
      expect(await database.employeeInfoDao.get('ABC123'), isEmpty);
    });
  });

  group('resetDb', () {
    test('limpa condomínio e colaboradores', () async {
      await database.condominiumInfoDao.insert(_condoInfo());
      await database.employeeInfoDao.insert(_employeeInfo());

      await database.resetDb();

      expect(await database.condominiumInfoDao.get('ABC123'), isNull);
      expect(await database.employeeInfoDao.get('ABC123'), isEmpty);
    });
  });

  group('migration', () {
    test('onCreate cria todas as tabelas', () async {
      await database.migration.onCreate(database.createMigrator());

      expect(database.allTables, isNotEmpty);
      expect(await database.employeeInfoDao.get('ABC123'), isEmpty);
    });

    test('onUpgrade a partir da versão 1 mantém o banco utilizável', () async {
      await database.migration.onUpgrade(database.createMigrator(), 1, 3);

      expect(await database.employeeInfoDao.get('ABC123'), isEmpty);
      expect(await database.condominiumInfoDao.get('ABC123'), isNull);
    });

    test('onUpgrade a partir da versão 2 mantém o banco utilizável', () async {
      await database.migration.onUpgrade(database.createMigrator(), 2, 3);

      expect(await database.condominiumInfoDao.get('ABC123'), isNull);
    });

    test('onUpgrade sem regra correspondente não altera nada', () async {
      await database.condominiumInfoDao.insert(_condoInfo());

      await database.migration.onUpgrade(database.createMigrator(), 3, 3);

      expect(await database.condominiumInfoDao.get('ABC123'), isNotNull);
    });
  });
}
