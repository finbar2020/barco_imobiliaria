// Testes do código gerado pelo drift: cada data class, companion e
// manager é exercitado (json, cópia, igualdade, filtros e ordenação).
import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/init_sqflite_ffi.dart';

void main() {
  initSqfliteForTests();

  late LelloDatabase database;

  setUp(() async {
    database = LelloDatabase();
    await database.resetDb();
  });

  tearDown(() => database.close());

  group('CondominiumData', () {
    final completo = CondominiumData(
        id: 'a1',
        meId: 'a1',
        reference: 'a1',
        name: 'a1',
        jobPosition: 'a1',
        workShift: 'a1',
        digitalTimesheetStatus: 'a1',
        usesDigitalTimesheet: true,
        workLeaveDescription: 'a1',
        shouldIgnoreDigitalPoint: true,
        latitude: 'a1',
        longitude: 'a1');
    final outro = CondominiumData(
        id: 'b2',
        meId: 'b2',
        reference: 'b2',
        name: 'b2',
        jobPosition: 'b2',
        workShift: 'b2',
        digitalTimesheetStatus: 'b2',
        usesDigitalTimesheet: false,
        workLeaveDescription: 'b2',
        shouldIgnoreDigitalPoint: false,
        latitude: 'b2',
        longitude: 'b2');
    final semOpcionais = CondominiumData(id: 'a1', meId: 'a1', reference: 'a1');

    test('json de ida e volta preserva os dados', () {
      expect(CondominiumData.fromJson(completo.toJson()), completo);
      expect(CondominiumData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          CondominiumData(
              id: 'a1',
              meId: 'a1',
              reference: 'a1',
              name: 'a1',
              jobPosition: 'a1',
              workShift: 'a1',
              digitalTimesheetStatus: 'a1',
              usesDigitalTimesheet: true,
              workLeaveDescription: 'a1',
              shouldIgnoreDigitalPoint: true,
              latitude: 'a1',
              longitude: 'a1'));
      expect(
          completo.hashCode,
          CondominiumData(
                  id: 'a1',
                  meId: 'a1',
                  reference: 'a1',
                  name: 'a1',
                  jobPosition: 'a1',
                  workShift: 'a1',
                  digitalTimesheetStatus: 'a1',
                  usesDigitalTimesheet: true,
                  workLeaveDescription: 'a1',
                  shouldIgnoreDigitalPoint: true,
                  latitude: 'a1',
                  longitude: 'a1')
              .hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('CondominiumData('));
      expect(completo.toString(), contains('id'));
      expect(completo.toString(), contains('meId'));
      expect(completo.toString(), contains('reference'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              id: 'b2',
              meId: 'b2',
              reference: 'b2',
              name: Value('b2'),
              jobPosition: Value('b2'),
              workShift: Value('b2'),
              digitalTimesheetStatus: Value('b2'),
              usesDigitalTimesheet: Value(false),
              workLeaveDescription: Value('b2'),
              shouldIgnoreDigitalPoint: Value(false),
              latitude: Value('b2'),
              longitude: Value('b2')),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(CondominiumTableCompanion(
            id: Value('b2'),
            meId: Value('b2'),
            reference: Value('b2'),
            name: Value('b2'),
            jobPosition: Value('b2'),
            workShift: Value('b2'),
            digitalTimesheetStatus: Value('b2'),
            usesDigitalTimesheet: Value(false),
            workLeaveDescription: Value('b2'),
            shouldIgnoreDigitalPoint: Value(false),
            latitude: Value('b2'),
            longitude: Value('b2'))),
        outro,
      );
      expect(completo.copyWithCompanion(const CondominiumTableCompanion()),
          completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).id.value, 'a1');
      expect(semOpcionais.toCompanion(true).name.present, isFalse);
      expect(semOpcionais.toCompanion(false).name.present, isTrue);
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
      expect(semOpcionais.toColumns(true).length,
          lessThan(completo.toColumns(true).length));
    });
  });

  group('CondominiumTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = CondominiumTableCompanion.insert(
          id: 'a1',
          meId: 'a1',
          reference: 'a1',
          name: Value('a1'),
          jobPosition: Value('a1'),
          workShift: Value('a1'),
          digitalTimesheetStatus: Value('a1'),
          usesDigitalTimesheet: Value(true),
          workLeaveDescription: Value('a1'),
          shouldIgnoreDigitalPoint: Value(true),
          latitude: Value('a1'),
          longitude: Value('a1'));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('CondominiumTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const CondominiumTableCompanion().copyWith(
          id: Value('b2'),
          meId: Value('b2'),
          reference: Value('b2'),
          name: Value('b2'),
          jobPosition: Value('b2'),
          workShift: Value('b2'),
          digitalTimesheetStatus: Value('b2'),
          usesDigitalTimesheet: Value(false),
          workLeaveDescription: Value('b2'),
          shouldIgnoreDigitalPoint: Value(false),
          latitude: Value('b2'),
          longitude: Value('b2'),
          rowid: Value(2));
      expect(companion.id.value, 'b2');
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const CondominiumTableCompanion().copyWith(
          id: Value('b2'),
          meId: Value('b2'),
          reference: Value('b2'),
          name: Value('b2'),
          jobPosition: Value('b2'),
          workShift: Value('b2'),
          digitalTimesheetStatus: Value('b2'),
          usesDigitalTimesheet: Value(false),
          workLeaveDescription: Value('b2'),
          shouldIgnoreDigitalPoint: Value(false),
          latitude: Value('b2'),
          longitude: Value('b2'),
          rowid: Value(2));
      expect(original.copyWith().id.value, 'b2');
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        CondominiumTableCompanion.custom(
            id: Variable<String>('a1'),
            meId: Variable<String>('a1'),
            reference: Variable<String>('a1'),
            name: Variable<String>('a1'),
            jobPosition: Variable<String>('a1'),
            workShift: Variable<String>('a1'),
            digitalTimesheetStatus: Variable<String>('a1'),
            usesDigitalTimesheet: Variable<bool>(true),
            workLeaveDescription: Variable<String>('a1'),
            shouldIgnoreDigitalPoint: Variable<bool>(true),
            latitude: Variable<String>('a1'),
            longitude: Variable<String>('a1'),
            rowid: Variable<int>(1)),
        isA<Insertable<CondominiumData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const CondominiumTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('MeData', () {
    final completo = MeData(
        id: 'a1',
        name: 'a1',
        email: 'a1',
        cpf: 'a1',
        phone: 'a1',
        picture: 'a1',
        pictureHash: 'a1',
        updated: DateTime(2026, 1, 10, 8));
    final outro = MeData(
        id: 'b2',
        name: 'b2',
        email: 'b2',
        cpf: 'b2',
        phone: 'b2',
        picture: 'b2',
        pictureHash: 'b2',
        updated: DateTime(2026, 2, 11, 9));
    final semOpcionais = MeData(id: 'a1', updated: DateTime(2026, 1, 10, 8));

    test('json de ida e volta preserva os dados', () {
      expect(MeData.fromJson(completo.toJson()), completo);
      expect(MeData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          MeData(
              id: 'a1',
              name: 'a1',
              email: 'a1',
              cpf: 'a1',
              phone: 'a1',
              picture: 'a1',
              pictureHash: 'a1',
              updated: DateTime(2026, 1, 10, 8)));
      expect(
          completo.hashCode,
          MeData(
                  id: 'a1',
                  name: 'a1',
                  email: 'a1',
                  cpf: 'a1',
                  phone: 'a1',
                  picture: 'a1',
                  pictureHash: 'a1',
                  updated: DateTime(2026, 1, 10, 8))
              .hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('MeData('));
      expect(completo.toString(), contains('id'));
      expect(completo.toString(), contains('name'));
      expect(completo.toString(), contains('email'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              id: 'b2',
              name: Value('b2'),
              email: Value('b2'),
              cpf: Value('b2'),
              phone: Value('b2'),
              picture: Value('b2'),
              pictureHash: Value('b2'),
              updated: DateTime(2026, 2, 11, 9)),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(MeTableCompanion(
            id: Value('b2'),
            name: Value('b2'),
            email: Value('b2'),
            cpf: Value('b2'),
            phone: Value('b2'),
            picture: Value('b2'),
            pictureHash: Value('b2'),
            updated: Value(DateTime(2026, 2, 11, 9)))),
        outro,
      );
      expect(completo.copyWithCompanion(const MeTableCompanion()), completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).id.value, 'a1');
      expect(semOpcionais.toCompanion(true).name.present, isFalse);
      expect(semOpcionais.toCompanion(false).name.present, isTrue);
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
      expect(semOpcionais.toColumns(true).length,
          lessThan(completo.toColumns(true).length));
    });
  });

  group('MeTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = MeTableCompanion.insert(
          id: 'a1',
          name: Value('a1'),
          email: Value('a1'),
          cpf: Value('a1'),
          phone: Value('a1'),
          picture: Value('a1'),
          pictureHash: Value('a1'),
          updated: DateTime(2026, 1, 10, 8));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('MeTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const MeTableCompanion().copyWith(
          id: Value('b2'),
          name: Value('b2'),
          email: Value('b2'),
          cpf: Value('b2'),
          phone: Value('b2'),
          picture: Value('b2'),
          pictureHash: Value('b2'),
          updated: Value(DateTime(2026, 2, 11, 9)),
          rowid: Value(2));
      expect(companion.id.value, 'b2');
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const MeTableCompanion().copyWith(
          id: Value('b2'),
          name: Value('b2'),
          email: Value('b2'),
          cpf: Value('b2'),
          phone: Value('b2'),
          picture: Value('b2'),
          pictureHash: Value('b2'),
          updated: Value(DateTime(2026, 2, 11, 9)),
          rowid: Value(2));
      expect(original.copyWith().id.value, 'b2');
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        MeTableCompanion.custom(
            id: Variable<String>('a1'),
            name: Variable<String>('a1'),
            email: Variable<String>('a1'),
            cpf: Variable<String>('a1'),
            phone: Variable<String>('a1'),
            picture: Variable<String>('a1'),
            pictureHash: Variable<String>('a1'),
            updated: Variable<DateTime>(DateTime(2026, 1, 10, 8)),
            rowid: Variable<int>(1)),
        isA<Insertable<MeData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const MeTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('EmployeeData', () {
    final completo = EmployeeData(
        condominiumId: 'a1',
        id: 'a1',
        name: 'a1',
        dob: DateTime(2026, 1, 10, 8),
        role: 'a1',
        hiringDate: DateTime(2026, 1, 10, 8),
        phone: 'a1',
        phone2: 'a1',
        address: 'a1',
        addressNumber: 'a1',
        addressComplement: 'a1',
        salary: 1.5,
        schooling: 'a1',
        status: 'a1');
    final outro = EmployeeData(
        condominiumId: 'b2',
        id: 'b2',
        name: 'b2',
        dob: DateTime(2026, 2, 11, 9),
        role: 'b2',
        hiringDate: DateTime(2026, 2, 11, 9),
        phone: 'b2',
        phone2: 'b2',
        address: 'b2',
        addressNumber: 'b2',
        addressComplement: 'b2',
        salary: 2.5,
        schooling: 'b2',
        status: 'b2');
    final semOpcionais = EmployeeData(condominiumId: 'a1', id: 'a1');

    test('json de ida e volta preserva os dados', () {
      expect(EmployeeData.fromJson(completo.toJson()), completo);
      expect(EmployeeData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          EmployeeData(
              condominiumId: 'a1',
              id: 'a1',
              name: 'a1',
              dob: DateTime(2026, 1, 10, 8),
              role: 'a1',
              hiringDate: DateTime(2026, 1, 10, 8),
              phone: 'a1',
              phone2: 'a1',
              address: 'a1',
              addressNumber: 'a1',
              addressComplement: 'a1',
              salary: 1.5,
              schooling: 'a1',
              status: 'a1'));
      expect(
          completo.hashCode,
          EmployeeData(
                  condominiumId: 'a1',
                  id: 'a1',
                  name: 'a1',
                  dob: DateTime(2026, 1, 10, 8),
                  role: 'a1',
                  hiringDate: DateTime(2026, 1, 10, 8),
                  phone: 'a1',
                  phone2: 'a1',
                  address: 'a1',
                  addressNumber: 'a1',
                  addressComplement: 'a1',
                  salary: 1.5,
                  schooling: 'a1',
                  status: 'a1')
              .hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('EmployeeData('));
      expect(completo.toString(), contains('condominiumId'));
      expect(completo.toString(), contains('id'));
      expect(completo.toString(), contains('name'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              condominiumId: 'b2',
              id: 'b2',
              name: Value('b2'),
              dob: Value(DateTime(2026, 2, 11, 9)),
              role: Value('b2'),
              hiringDate: Value(DateTime(2026, 2, 11, 9)),
              phone: Value('b2'),
              phone2: Value('b2'),
              address: Value('b2'),
              addressNumber: Value('b2'),
              addressComplement: Value('b2'),
              salary: Value(2.5),
              schooling: Value('b2'),
              status: Value('b2')),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(EmployeeTableCompanion(
            condominiumId: Value('b2'),
            id: Value('b2'),
            name: Value('b2'),
            dob: Value(DateTime(2026, 2, 11, 9)),
            role: Value('b2'),
            hiringDate: Value(DateTime(2026, 2, 11, 9)),
            phone: Value('b2'),
            phone2: Value('b2'),
            address: Value('b2'),
            addressNumber: Value('b2'),
            addressComplement: Value('b2'),
            salary: Value(2.5),
            schooling: Value('b2'),
            status: Value('b2'))),
        outro,
      );
      expect(
          completo.copyWithCompanion(const EmployeeTableCompanion()), completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).condominiumId.value, 'a1');
      expect(semOpcionais.toCompanion(true).name.present, isFalse);
      expect(semOpcionais.toCompanion(false).name.present, isTrue);
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
      expect(semOpcionais.toColumns(true).length,
          lessThan(completo.toColumns(true).length));
    });
  });

  group('EmployeeTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = EmployeeTableCompanion.insert(
          condominiumId: 'a1',
          id: 'a1',
          name: Value('a1'),
          dob: Value(DateTime(2026, 1, 10, 8)),
          role: Value('a1'),
          hiringDate: Value(DateTime(2026, 1, 10, 8)),
          phone: Value('a1'),
          phone2: Value('a1'),
          address: Value('a1'),
          addressNumber: Value('a1'),
          addressComplement: Value('a1'),
          salary: Value(1.5),
          schooling: Value('a1'),
          status: Value('a1'));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('EmployeeTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const EmployeeTableCompanion().copyWith(
          condominiumId: Value('b2'),
          id: Value('b2'),
          name: Value('b2'),
          dob: Value(DateTime(2026, 2, 11, 9)),
          role: Value('b2'),
          hiringDate: Value(DateTime(2026, 2, 11, 9)),
          phone: Value('b2'),
          phone2: Value('b2'),
          address: Value('b2'),
          addressNumber: Value('b2'),
          addressComplement: Value('b2'),
          salary: Value(2.5),
          schooling: Value('b2'),
          status: Value('b2'),
          rowid: Value(2));
      expect(companion.condominiumId.value, 'b2');
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const EmployeeTableCompanion().copyWith(
          condominiumId: Value('b2'),
          id: Value('b2'),
          name: Value('b2'),
          dob: Value(DateTime(2026, 2, 11, 9)),
          role: Value('b2'),
          hiringDate: Value(DateTime(2026, 2, 11, 9)),
          phone: Value('b2'),
          phone2: Value('b2'),
          address: Value('b2'),
          addressNumber: Value('b2'),
          addressComplement: Value('b2'),
          salary: Value(2.5),
          schooling: Value('b2'),
          status: Value('b2'),
          rowid: Value(2));
      expect(original.copyWith().condominiumId.value, 'b2');
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        EmployeeTableCompanion.custom(
            condominiumId: Variable<String>('a1'),
            id: Variable<String>('a1'),
            name: Variable<String>('a1'),
            dob: Variable<DateTime>(DateTime(2026, 1, 10, 8)),
            role: Variable<String>('a1'),
            hiringDate: Variable<DateTime>(DateTime(2026, 1, 10, 8)),
            phone: Variable<String>('a1'),
            phone2: Variable<String>('a1'),
            address: Variable<String>('a1'),
            addressNumber: Variable<String>('a1'),
            addressComplement: Variable<String>('a1'),
            salary: Variable<double>(1.5),
            schooling: Variable<String>('a1'),
            status: Variable<String>('a1'),
            rowid: Variable<int>(1)),
        isA<Insertable<EmployeeData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const EmployeeTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('CondominiumEmployeeScheduleData', () {
    final completo = CondominiumEmployeeScheduleData(
        reference: 'a1',
        date: DateTime(2026, 1, 10, 8),
        badageNumber: 'a1',
        entry1: 'a1',
        out1: 'a1',
        entry2: 'a1',
        out2: 'a1',
        isDayOff: true);
    final outro = CondominiumEmployeeScheduleData(
        reference: 'b2',
        date: DateTime(2026, 2, 11, 9),
        badageNumber: 'b2',
        entry1: 'b2',
        out1: 'b2',
        entry2: 'b2',
        out2: 'b2',
        isDayOff: false);

    test('json de ida e volta preserva os dados', () {
      expect(CondominiumEmployeeScheduleData.fromJson(completo.toJson()),
          completo);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          CondominiumEmployeeScheduleData(
              reference: 'a1',
              date: DateTime(2026, 1, 10, 8),
              badageNumber: 'a1',
              entry1: 'a1',
              out1: 'a1',
              entry2: 'a1',
              out2: 'a1',
              isDayOff: true));
      expect(
          completo.hashCode,
          CondominiumEmployeeScheduleData(
                  reference: 'a1',
                  date: DateTime(2026, 1, 10, 8),
                  badageNumber: 'a1',
                  entry1: 'a1',
                  out1: 'a1',
                  entry2: 'a1',
                  out2: 'a1',
                  isDayOff: true)
              .hashCode);
      expect(completo == outro, isFalse);
      expect(
          completo.toString(), startsWith('CondominiumEmployeeScheduleData('));
      expect(completo.toString(), contains('reference'));
      expect(completo.toString(), contains('date'));
      expect(completo.toString(), contains('badageNumber'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              reference: 'b2',
              date: DateTime(2026, 2, 11, 9),
              badageNumber: 'b2',
              entry1: 'b2',
              out1: 'b2',
              entry2: 'b2',
              out2: 'b2',
              isDayOff: false),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(CondominiumEmployeeScheduleTableCompanion(
            reference: Value('b2'),
            date: Value(DateTime(2026, 2, 11, 9)),
            badageNumber: Value('b2'),
            entry1: Value('b2'),
            out1: Value('b2'),
            entry2: Value('b2'),
            out2: Value('b2'),
            isDayOff: Value(false))),
        outro,
      );
      expect(
          completo.copyWithCompanion(
              const CondominiumEmployeeScheduleTableCompanion()),
          completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).reference.value, 'a1');
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
    });
  });

  group('CondominiumEmployeeScheduleTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = CondominiumEmployeeScheduleTableCompanion.insert(
          reference: 'a1',
          date: DateTime(2026, 1, 10, 8),
          badageNumber: 'a1',
          entry1: 'a1',
          out1: 'a1',
          entry2: 'a1',
          out2: 'a1',
          isDayOff: true);
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(),
          startsWith('CondominiumEmployeeScheduleTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const CondominiumEmployeeScheduleTableCompanion()
          .copyWith(
              reference: Value('b2'),
              date: Value(DateTime(2026, 2, 11, 9)),
              badageNumber: Value('b2'),
              entry1: Value('b2'),
              out1: Value('b2'),
              entry2: Value('b2'),
              out2: Value('b2'),
              isDayOff: Value(false),
              rowid: Value(2));
      expect(companion.reference.value, 'b2');
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const CondominiumEmployeeScheduleTableCompanion()
          .copyWith(
              reference: Value('b2'),
              date: Value(DateTime(2026, 2, 11, 9)),
              badageNumber: Value('b2'),
              entry1: Value('b2'),
              out1: Value('b2'),
              entry2: Value('b2'),
              out2: Value('b2'),
              isDayOff: Value(false),
              rowid: Value(2));
      expect(original.copyWith().reference.value, 'b2');
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        CondominiumEmployeeScheduleTableCompanion.custom(
            reference: Variable<String>('a1'),
            date: Variable<DateTime>(DateTime(2026, 1, 10, 8)),
            badageNumber: Variable<String>('a1'),
            entry1: Variable<String>('a1'),
            out1: Variable<String>('a1'),
            entry2: Variable<String>('a1'),
            out2: Variable<String>('a1'),
            isDayOff: Variable<bool>(true),
            rowid: Variable<int>(1)),
        isA<Insertable<CondominiumEmployeeScheduleData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const CondominiumEmployeeScheduleTableCompanion().toColumns(false),
          isEmpty);
    });
  });

  group('escrita direta nas tabelas', () {
    test('condominiumTable aceita um companion completo', () async {
      await database.into(database.condominiumTable).insert(
            CondominiumTableCompanion.insert(
                id: 'a1',
                meId: 'a1',
                reference: 'a1',
                name: Value('a1'),
                jobPosition: Value('a1'),
                workShift: Value('a1'),
                digitalTimesheetStatus: Value('a1'),
                usesDigitalTimesheet: Value(true),
                workLeaveDescription: Value('a1'),
                shouldIgnoreDigitalPoint: Value(true),
                latitude: Value('a1'),
                longitude: Value('a1')),
          );

      expect(
          await database.select(database.condominiumTable).get(), hasLength(1));
    });

    test('condominiumTable recusa companion sem os campos obrigatórios', () {
      expect(
        () => database
            .into(database.condominiumTable)
            .insert(const CondominiumTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });

    test('meTable aceita um companion completo', () async {
      await database.into(database.meTable).insert(
            MeTableCompanion.insert(
                id: 'a1',
                name: Value('a1'),
                email: Value('a1'),
                cpf: Value('a1'),
                phone: Value('a1'),
                picture: Value('a1'),
                pictureHash: Value('a1'),
                updated: DateTime(2026, 1, 10, 8)),
          );

      expect(await database.select(database.meTable).get(), hasLength(1));
    });

    test('meTable recusa companion sem os campos obrigatórios', () {
      expect(
        () => database.into(database.meTable).insert(const MeTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });

    test('employeeTable aceita um companion completo', () async {
      await database.into(database.employeeTable).insert(
            EmployeeTableCompanion.insert(
                condominiumId: 'a1',
                id: 'a1',
                name: Value('a1'),
                dob: Value(DateTime(2026, 1, 10, 8)),
                role: Value('a1'),
                hiringDate: Value(DateTime(2026, 1, 10, 8)),
                phone: Value('a1'),
                phone2: Value('a1'),
                address: Value('a1'),
                addressNumber: Value('a1'),
                addressComplement: Value('a1'),
                salary: Value(1.5),
                schooling: Value('a1'),
                status: Value('a1')),
          );

      expect(await database.select(database.employeeTable).get(), hasLength(1));
    });

    test('employeeTable recusa companion sem os campos obrigatórios', () {
      expect(
        () => database
            .into(database.employeeTable)
            .insert(const EmployeeTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });

    test('condominiumEmployeeScheduleTable aceita um companion completo',
        () async {
      await database.into(database.condominiumEmployeeScheduleTable).insert(
            CondominiumEmployeeScheduleTableCompanion.insert(
                reference: 'a1',
                date: DateTime(2026, 1, 10, 8),
                badageNumber: 'a1',
                entry1: 'a1',
                out1: 'a1',
                entry2: 'a1',
                out2: 'a1',
                isDayOff: true),
          );

      expect(
          await database
              .select(database.condominiumEmployeeScheduleTable)
              .get(),
          hasLength(1));
    });

    test(
        'condominiumEmployeeScheduleTable recusa companion sem os campos obrigatórios',
        () {
      expect(
        () => database
            .into(database.condominiumEmployeeScheduleTable)
            .insert(const CondominiumEmployeeScheduleTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });
  });

  group('tabelas geradas', () {
    test('condominiumTable expõe alias e chave primária', () {
      final alias = database.condominiumTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.condominiumTable.$columns, isNotEmpty);
      expect(database.condominiumTable.$primaryKey, isNotNull);
    });

    test('meTable expõe alias e chave primária', () {
      final alias = database.meTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.meTable.$columns, isNotEmpty);
      expect(database.meTable.$primaryKey, isNotNull);
    });

    test('employeeTable expõe alias e chave primária', () {
      final alias = database.employeeTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.employeeTable.$columns, isNotEmpty);
      expect(database.employeeTable.$primaryKey, isNotNull);
    });

    test('condominiumEmployeeScheduleTable expõe alias e chave primária', () {
      final alias = database.condominiumEmployeeScheduleTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.condominiumEmployeeScheduleTable.$columns, isNotEmpty);
      expect(database.condominiumEmployeeScheduleTable.$primaryKey, isNotNull);
    });
  });

  group('managers gerados', () {
    test('condominiumTable filtra, ordena e escreve', () async {
      final m = database.managers.condominiumTable;
      await m.create((o) => o(id: 'a1', meId: 'a1', reference: 'a1'));

      expect(
          await m
              .filter((f) =>
                  f.id.equals('a1') &
                  f.meId.equals('a1') &
                  f.reference.equals('a1') &
                  f.name.equals('a1') &
                  f.jobPosition.equals('a1') &
                  f.workShift.equals('a1') &
                  f.digitalTimesheetStatus.equals('a1') &
                  f.usesDigitalTimesheet.equals(true) &
                  f.workLeaveDescription.equals('a1') &
                  f.shouldIgnoreDigitalPoint.equals(true) &
                  f.latitude.equals('a1') &
                  f.longitude.equals('a1'))
              .get(),
          isA<List<CondominiumData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.id.asc() &
                  o.meId.asc() &
                  o.reference.asc() &
                  o.name.asc() &
                  o.jobPosition.asc() &
                  o.workShift.asc() &
                  o.digitalTimesheetStatus.asc() &
                  o.usesDigitalTimesheet.asc() &
                  o.workLeaveDescription.asc() &
                  o.shouldIgnoreDigitalPoint.asc() &
                  o.latitude.asc() &
                  o.longitude.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.meId),
        m.computedField((a) => a.reference),
        m.computedField((a) => a.name),
        m.computedField((a) => a.jobPosition),
        m.computedField((a) => a.workShift),
        m.computedField((a) => a.digitalTimesheetStatus),
        m.computedField((a) => a.usesDigitalTimesheet),
        m.computedField((a) => a.workLeaveDescription),
        m.computedField((a) => a.shouldIgnoreDigitalPoint),
        m.computedField((a) => a.latitude),
        m.computedField((a) => a.longitude)
      ], hasLength(12));
      expect(
          await m.update((o) => o(
              id: Value('b2'),
              meId: Value('b2'),
              reference: Value('b2'),
              name: Value('b2'),
              jobPosition: Value('b2'),
              workShift: Value('b2'),
              digitalTimesheetStatus: Value('b2'),
              usesDigitalTimesheet: Value(false),
              workLeaveDescription: Value('b2'),
              shouldIgnoreDigitalPoint: Value(false),
              latitude: Value('b2'),
              longitude: Value('b2'))),
          1);
      expect(await m.delete(), 1);
    });

    test('meTable filtra, ordena e escreve', () async {
      final m = database.managers.meTable;
      await m.create((o) => o(id: 'a1', updated: DateTime(2026, 1, 10, 8)));

      expect(
          await m
              .filter((f) =>
                  f.id.equals('a1') &
                  f.name.equals('a1') &
                  f.email.equals('a1') &
                  f.cpf.equals('a1') &
                  f.phone.equals('a1') &
                  f.picture.equals('a1') &
                  f.pictureHash.equals('a1') &
                  f.updated.equals(DateTime(2026, 1, 10, 8)))
              .get(),
          isA<List<MeData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.id.asc() &
                  o.name.asc() &
                  o.email.asc() &
                  o.cpf.asc() &
                  o.phone.asc() &
                  o.picture.asc() &
                  o.pictureHash.asc() &
                  o.updated.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.name),
        m.computedField((a) => a.email),
        m.computedField((a) => a.cpf),
        m.computedField((a) => a.phone),
        m.computedField((a) => a.picture),
        m.computedField((a) => a.pictureHash),
        m.computedField((a) => a.updated)
      ], hasLength(8));
      expect(
          await m.update((o) => o(
              id: Value('b2'),
              name: Value('b2'),
              email: Value('b2'),
              cpf: Value('b2'),
              phone: Value('b2'),
              picture: Value('b2'),
              pictureHash: Value('b2'),
              updated: Value(DateTime(2026, 2, 11, 9)))),
          1);
      expect(await m.delete(), 1);
    });

    test('employeeTable filtra, ordena e escreve', () async {
      final m = database.managers.employeeTable;
      await m.create((o) => o(condominiumId: 'a1', id: 'a1'));

      expect(
          await m
              .filter((f) =>
                  f.condominiumId.equals('a1') &
                  f.id.equals('a1') &
                  f.name.equals('a1') &
                  f.dob.equals(DateTime(2026, 1, 10, 8)) &
                  f.role.equals('a1') &
                  f.hiringDate.equals(DateTime(2026, 1, 10, 8)) &
                  f.phone.equals('a1') &
                  f.phone2.equals('a1') &
                  f.address.equals('a1') &
                  f.addressNumber.equals('a1') &
                  f.addressComplement.equals('a1') &
                  f.salary.equals(1.5) &
                  f.schooling.equals('a1') &
                  f.status.equals('a1'))
              .get(),
          isA<List<EmployeeData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.condominiumId.asc() &
                  o.id.asc() &
                  o.name.asc() &
                  o.dob.asc() &
                  o.role.asc() &
                  o.hiringDate.asc() &
                  o.phone.asc() &
                  o.phone2.asc() &
                  o.address.asc() &
                  o.addressNumber.asc() &
                  o.addressComplement.asc() &
                  o.salary.asc() &
                  o.schooling.asc() &
                  o.status.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.condominiumId),
        m.computedField((a) => a.id),
        m.computedField((a) => a.name),
        m.computedField((a) => a.dob),
        m.computedField((a) => a.role),
        m.computedField((a) => a.hiringDate),
        m.computedField((a) => a.phone),
        m.computedField((a) => a.phone2),
        m.computedField((a) => a.address),
        m.computedField((a) => a.addressNumber),
        m.computedField((a) => a.addressComplement),
        m.computedField((a) => a.salary),
        m.computedField((a) => a.schooling),
        m.computedField((a) => a.status)
      ], hasLength(14));
      expect(
          await m.update((o) => o(
              condominiumId: Value('b2'),
              id: Value('b2'),
              name: Value('b2'),
              dob: Value(DateTime(2026, 2, 11, 9)),
              role: Value('b2'),
              hiringDate: Value(DateTime(2026, 2, 11, 9)),
              phone: Value('b2'),
              phone2: Value('b2'),
              address: Value('b2'),
              addressNumber: Value('b2'),
              addressComplement: Value('b2'),
              salary: Value(2.5),
              schooling: Value('b2'),
              status: Value('b2'))),
          1);
      expect(await m.delete(), 1);
    });

    test('condominiumEmployeeScheduleTable filtra, ordena e escreve', () async {
      final m = database.managers.condominiumEmployeeScheduleTable;
      await m.create((o) => o(
          reference: 'a1',
          date: DateTime(2026, 1, 10, 8),
          badageNumber: 'a1',
          entry1: 'a1',
          out1: 'a1',
          entry2: 'a1',
          out2: 'a1',
          isDayOff: true));

      expect(
          await m
              .filter((f) =>
                  f.reference.equals('a1') &
                  f.date.equals(DateTime(2026, 1, 10, 8)) &
                  f.badageNumber.equals('a1') &
                  f.entry1.equals('a1') &
                  f.out1.equals('a1') &
                  f.entry2.equals('a1') &
                  f.out2.equals('a1') &
                  f.isDayOff.equals(true))
              .get(),
          isA<List<CondominiumEmployeeScheduleData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.reference.asc() &
                  o.date.asc() &
                  o.badageNumber.asc() &
                  o.entry1.asc() &
                  o.out1.asc() &
                  o.entry2.asc() &
                  o.out2.asc() &
                  o.isDayOff.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.reference),
        m.computedField((a) => a.date),
        m.computedField((a) => a.badageNumber),
        m.computedField((a) => a.entry1),
        m.computedField((a) => a.out1),
        m.computedField((a) => a.entry2),
        m.computedField((a) => a.out2),
        m.computedField((a) => a.isDayOff)
      ], hasLength(8));
      expect(
          await m.update((o) => o(
              reference: Value('b2'),
              date: Value(DateTime(2026, 2, 11, 9)),
              badageNumber: Value('b2'),
              entry1: Value('b2'),
              out1: Value('b2'),
              entry2: Value('b2'),
              out2: Value('b2'),
              isDayOff: Value(false))),
          1);
      expect(await m.delete(), 1);
    });
  });
}
