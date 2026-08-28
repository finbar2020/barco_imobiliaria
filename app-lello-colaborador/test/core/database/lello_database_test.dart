import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/init_sqflite_ffi.dart';

CondominiumTableCompanion _condominium({
  String id = 'c1',
  String meId = 'm1',
  String reference = 'R1',
}) =>
    CondominiumTableCompanion.insert(
      id: id,
      meId: meId,
      reference: reference,
      name: const Value('Torre Lello'),
      jobPosition: const Value('porteiro'),
      workShift: const Value('diurno'),
      digitalTimesheetStatus: const Value('APPROVED'),
      usesDigitalTimesheet: const Value(true),
      workLeaveDescription: const Value(''),
      shouldIgnoreDigitalPoint: const Value(false),
      latitude: const Value('-23.5'),
      longitude: const Value('-46.6'),
    );

MeTableCompanion _me({String id = 'm1', String name = 'Ana Silva'}) =>
    MeTableCompanion.insert(
      id: id,
      updated: DateTime(2026, 1, 10),
      name: Value(name),
      email: const Value('ana@lello.com'),
      cpf: const Value('12345678901'),
      phone: const Value('11999999999'),
    );

EmployeeTableCompanion _employee({
  String condominiumId = 'c1',
  String id = 'e1',
  String name = 'Bruno',
}) =>
    EmployeeTableCompanion.insert(
      condominiumId: condominiumId,
      id: id,
      name: Value(name),
      role: const Value('zelador'),
      status: const Value('ativo'),
      salary: const Value(2500.0),
    );

CondominiumEmployeeScheduleTableCompanion _schedule({
  String reference = 'R1',
  DateTime? date,
}) =>
    CondominiumEmployeeScheduleTableCompanion.insert(
      reference: reference,
      date: date ?? DateTime(2026, 1, 10),
      badageNumber: '10',
      entry1: '08:00',
      out1: '12:00',
      entry2: '13:00',
      out2: '17:00',
      isDayOff: false,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  late LelloDatabase database;

  setUp(() async {
    database = LelloDatabase();
    await database.resetDb();
  });

  tearDown(() async {
    await database.close();
  });

  group('MeDao', () {
    test('guarda e devolve o colaborador logado', () async {
      await database.meDao.insert(_me());

      final stored = await database.meDao.get();

      expect(stored?.id, 'm1');
      expect(stored?.name, 'Ana Silva');
      expect(stored?.email, 'ana@lello.com');
    });

    test('regravar o mesmo id substitui os dados', () async {
      await database.meDao.insert(_me());
      await database.meDao.insert(_me(name: 'Ana Atualizada'));

      final stored = await database.meDao.get();

      expect(stored?.name, 'Ana Atualizada');
    });

    test('clear apaga o colaborador guardado', () async {
      await database.meDao.insert(_me());

      final removed = await database.meDao.clear();

      expect(removed, 1);
      expect(await database.meDao.get(), isNull);
    });
  });

  group('CondominiumDao', () {
    test('lista os condomínios do colaborador', () async {
      await database.condominiumDao.insert(_condominium());
      await database.condominiumDao.insert(
        _condominium(id: 'c2', reference: 'R2'),
      );
      await database.condominiumDao.insert(
        _condominium(id: 'c3', meId: 'outro'),
      );

      final list = await database.condominiumDao.list('m1');

      expect(list.map((e) => e.id), ['c1', 'c2']);
      expect(list.first.latitude, '-23.5');
    });

    test('busca um condomínio pelo id', () async {
      await database.condominiumDao.insert(_condominium());

      final found = await database.condominiumDao.getSingle('c1');
      final missing = await database.condominiumDao.getSingle('c9');

      expect(found?.reference, 'R1');
      expect(missing, isNull);
    });

    test('clear apaga os condomínios', () async {
      await database.condominiumDao.insert(_condominium());

      final removed = await database.condominiumDao.clear();

      expect(removed, 1);
      expect(await database.condominiumDao.list('m1'), isEmpty);
    });
  });

  group('EmployeeDao', () {
    test('lista os funcionários de um condomínio', () async {
      await database.employeeDao.insert([
        _employee(),
        _employee(id: 'e2', name: 'Carla'),
        _employee(condominiumId: 'c2', id: 'e3', name: 'Outro'),
      ]);

      final list = await database.employeeDao.list('c1');

      expect(list.map((e) => e.name), ['Bruno', 'Carla']);
      expect(list.first.salary, 2500.0);
    });

    test('regravar o mesmo funcionário substitui os dados', () async {
      await database.employeeDao.insert([_employee()]);
      await database.employeeDao.insert([_employee(name: 'Bruno Souza')]);

      final list = await database.employeeDao.list('c1');

      expect(list, hasLength(1));
      expect(list.single.name, 'Bruno Souza');
    });

    test('clear apaga apenas os funcionários', () async {
      await database.condominiumDao.insert(_condominium());
      await database.employeeDao.insert([_employee()]);

      final removed = await database.employeeDao.clear();

      expect(removed, 1);
      expect(await database.employeeDao.list('c1'), isEmpty);
      expect(await database.condominiumDao.list('m1'), hasLength(1));
    });
  });

  group('CondominiumEmployeeScheduleDao', () {
    test('lista a escala pela referência do condomínio', () async {
      await database.condominiumEmployeeScheduleDao.insert([
        _schedule(),
        _schedule(date: DateTime(2026, 1, 11)),
        _schedule(reference: 'R2'),
      ]);

      final list = await database.condominiumEmployeeScheduleDao.list('R1');

      expect(list, hasLength(2));
      expect(list.first.entry1, '08:00');
      expect(list.first.isDayOff, isFalse);
    });

    test('clear apaga apenas a escala', () async {
      await database.condominiumDao.insert(_condominium());
      await database.condominiumEmployeeScheduleDao.insert([_schedule()]);

      final removed = await database.condominiumEmployeeScheduleDao.clear();

      expect(removed, 1);
      expect(await database.condominiumEmployeeScheduleDao.list('R1'), isEmpty);
      expect(await database.condominiumDao.list('m1'), hasLength(1));
    });
  });

  group('resetDb', () {
    test('limpa todas as tabelas do banco', () async {
      await database.meDao.insert(_me());
      await database.condominiumDao.insert(_condominium());
      await database.employeeDao.insert([_employee()]);
      await database.condominiumEmployeeScheduleDao.insert([_schedule()]);

      await database.resetDb();

      expect(await database.meDao.get(), isNull);
      expect(await database.condominiumDao.list('m1'), isEmpty);
      expect(await database.employeeDao.list('c1'), isEmpty);
      expect(
        await database.condominiumEmployeeScheduleDao.list('R1'),
        isEmpty,
      );
    });
  });
}
