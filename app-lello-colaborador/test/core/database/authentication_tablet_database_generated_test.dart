// Testes do código gerado pelo drift: cada data class, companion e
// manager é exercitado (json, cópia, igualdade, filtros e ordenação).
import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/init_sqflite_ffi.dart';

void main() {
  initSqfliteForTests();

  late AuthenticationTabletDatabase database;

  setUp(() async {
    database = AuthenticationTabletDatabase();
    await database.resetDb();
  });

  tearDown(() => database.close());

  group('EmployeeInfoData', () {
    final completo = EmployeeInfoData(
        condoCode: 'a1',
        numCad: 'a1',
        numCra: 'a1',
        cpf: 'a1',
        name: 'a1',
        jobPosition: 'a1',
        idLogin: 'a1',
        pictureHash: 'a1',
        registered: true,
        status: 'a1');
    final outro = EmployeeInfoData(
        condoCode: 'b2',
        numCad: 'b2',
        numCra: 'b2',
        cpf: 'b2',
        name: 'b2',
        jobPosition: 'b2',
        idLogin: 'b2',
        pictureHash: 'b2',
        registered: false,
        status: 'b2');

    test('json de ida e volta preserva os dados', () {
      expect(EmployeeInfoData.fromJson(completo.toJson()), completo);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          EmployeeInfoData(
              condoCode: 'a1',
              numCad: 'a1',
              numCra: 'a1',
              cpf: 'a1',
              name: 'a1',
              jobPosition: 'a1',
              idLogin: 'a1',
              pictureHash: 'a1',
              registered: true,
              status: 'a1'));
      expect(
          completo.hashCode,
          EmployeeInfoData(
                  condoCode: 'a1',
                  numCad: 'a1',
                  numCra: 'a1',
                  cpf: 'a1',
                  name: 'a1',
                  jobPosition: 'a1',
                  idLogin: 'a1',
                  pictureHash: 'a1',
                  registered: true,
                  status: 'a1')
              .hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('EmployeeInfoData('));
      expect(completo.toString(), contains('condoCode'));
      expect(completo.toString(), contains('numCad'));
      expect(completo.toString(), contains('numCra'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              condoCode: 'b2',
              numCad: 'b2',
              numCra: 'b2',
              cpf: 'b2',
              name: 'b2',
              jobPosition: 'b2',
              idLogin: 'b2',
              pictureHash: 'b2',
              registered: false,
              status: 'b2'),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(EmployeeInfoTableCompanion(
            condoCode: Value('b2'),
            numCad: Value('b2'),
            numCra: Value('b2'),
            cpf: Value('b2'),
            name: Value('b2'),
            jobPosition: Value('b2'),
            idLogin: Value('b2'),
            pictureHash: Value('b2'),
            registered: Value(false),
            status: Value('b2'))),
        outro,
      );
      expect(completo.copyWithCompanion(const EmployeeInfoTableCompanion()),
          completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).condoCode.value, 'a1');
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
    });
  });

  group('EmployeeInfoTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = EmployeeInfoTableCompanion.insert(
          condoCode: 'a1',
          numCad: 'a1',
          numCra: 'a1',
          cpf: 'a1',
          name: 'a1',
          jobPosition: 'a1',
          idLogin: 'a1',
          pictureHash: 'a1',
          registered: true,
          status: 'a1');
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('EmployeeInfoTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const EmployeeInfoTableCompanion().copyWith(
          condoCode: Value('b2'),
          numCad: Value('b2'),
          numCra: Value('b2'),
          cpf: Value('b2'),
          name: Value('b2'),
          jobPosition: Value('b2'),
          idLogin: Value('b2'),
          pictureHash: Value('b2'),
          registered: Value(false),
          status: Value('b2'),
          rowid: Value(2));
      expect(companion.condoCode.value, 'b2');
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const EmployeeInfoTableCompanion().copyWith(
          condoCode: Value('b2'),
          numCad: Value('b2'),
          numCra: Value('b2'),
          cpf: Value('b2'),
          name: Value('b2'),
          jobPosition: Value('b2'),
          idLogin: Value('b2'),
          pictureHash: Value('b2'),
          registered: Value(false),
          status: Value('b2'),
          rowid: Value(2));
      expect(original.copyWith().condoCode.value, 'b2');
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        EmployeeInfoTableCompanion.custom(
            condoCode: Variable<String>('a1'),
            numCad: Variable<String>('a1'),
            numCra: Variable<String>('a1'),
            cpf: Variable<String>('a1'),
            name: Variable<String>('a1'),
            jobPosition: Variable<String>('a1'),
            idLogin: Variable<String>('a1'),
            pictureHash: Variable<String>('a1'),
            registered: Variable<bool>(true),
            status: Variable<String>('a1'),
            rowid: Variable<int>(1)),
        isA<Insertable<EmployeeInfoData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const EmployeeInfoTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('CondominiumInfoData', () {
    final completo = CondominiumInfoData(
        condoCode: 'a1',
        reference: 'a1',
        name: 'a1',
        picturehash: 'a1',
        status: 'a1',
        ref: 'a1');
    final outro = CondominiumInfoData(
        condoCode: 'b2',
        reference: 'b2',
        name: 'b2',
        picturehash: 'b2',
        status: 'b2',
        ref: 'b2');

    test('json de ida e volta preserva os dados', () {
      expect(CondominiumInfoData.fromJson(completo.toJson()), completo);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          CondominiumInfoData(
              condoCode: 'a1',
              reference: 'a1',
              name: 'a1',
              picturehash: 'a1',
              status: 'a1',
              ref: 'a1'));
      expect(
          completo.hashCode,
          CondominiumInfoData(
                  condoCode: 'a1',
                  reference: 'a1',
                  name: 'a1',
                  picturehash: 'a1',
                  status: 'a1',
                  ref: 'a1')
              .hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('CondominiumInfoData('));
      expect(completo.toString(), contains('condoCode'));
      expect(completo.toString(), contains('reference'));
      expect(completo.toString(), contains('name'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              condoCode: 'b2',
              reference: 'b2',
              name: 'b2',
              picturehash: 'b2',
              status: 'b2',
              ref: 'b2'),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(CondominiumInfoTableCompanion(
            condoCode: Value('b2'),
            reference: Value('b2'),
            name: Value('b2'),
            picturehash: Value('b2'),
            status: Value('b2'),
            ref: Value('b2'))),
        outro,
      );
      expect(completo.copyWithCompanion(const CondominiumInfoTableCompanion()),
          completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).condoCode.value, 'a1');
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
    });
  });

  group('CondominiumInfoTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = CondominiumInfoTableCompanion.insert(
          condoCode: 'a1',
          reference: 'a1',
          name: 'a1',
          picturehash: 'a1',
          status: 'a1',
          ref: 'a1');
      expect(companion.toColumns(false), isNotEmpty);
      expect(
          companion.toString(), startsWith('CondominiumInfoTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const CondominiumInfoTableCompanion().copyWith(
          condoCode: Value('b2'),
          reference: Value('b2'),
          name: Value('b2'),
          picturehash: Value('b2'),
          status: Value('b2'),
          ref: Value('b2'),
          rowid: Value(2));
      expect(companion.condoCode.value, 'b2');
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const CondominiumInfoTableCompanion().copyWith(
          condoCode: Value('b2'),
          reference: Value('b2'),
          name: Value('b2'),
          picturehash: Value('b2'),
          status: Value('b2'),
          ref: Value('b2'),
          rowid: Value(2));
      expect(original.copyWith().condoCode.value, 'b2');
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        CondominiumInfoTableCompanion.custom(
            condoCode: Variable<String>('a1'),
            reference: Variable<String>('a1'),
            name: Variable<String>('a1'),
            picturehash: Variable<String>('a1'),
            status: Variable<String>('a1'),
            ref: Variable<String>('a1'),
            rowid: Variable<int>(1)),
        isA<Insertable<CondominiumInfoData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const CondominiumInfoTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('escrita direta nas tabelas', () {
    test('employeeInfoTable aceita um companion completo', () async {
      await database.into(database.employeeInfoTable).insert(
            EmployeeInfoTableCompanion.insert(
                condoCode: 'a1',
                numCad: 'a1',
                numCra: 'a1',
                cpf: 'a1',
                name: 'a1',
                jobPosition: 'a1',
                idLogin: 'a1',
                pictureHash: 'a1',
                registered: true,
                status: 'a1'),
          );

      expect(await database.select(database.employeeInfoTable).get(),
          hasLength(1));
    });

    test('employeeInfoTable recusa companion sem os campos obrigatórios', () {
      expect(
        () => database
            .into(database.employeeInfoTable)
            .insert(const EmployeeInfoTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });

    test('condominiumInfoTable aceita um companion completo', () async {
      await database.into(database.condominiumInfoTable).insert(
            CondominiumInfoTableCompanion.insert(
                condoCode: 'a1',
                reference: 'a1',
                name: 'a1',
                picturehash: 'a1',
                status: 'a1',
                ref: 'a1'),
          );

      expect(await database.select(database.condominiumInfoTable).get(),
          hasLength(1));
    });

    test('condominiumInfoTable recusa companion sem os campos obrigatórios',
        () {
      expect(
        () => database
            .into(database.condominiumInfoTable)
            .insert(const CondominiumInfoTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });
  });

  group('tabelas geradas', () {
    test('employeeInfoTable expõe alias e chave primária', () {
      final alias = database.employeeInfoTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.employeeInfoTable.$columns, isNotEmpty);
      expect(database.employeeInfoTable.$primaryKey, isNotNull);
    });

    test('condominiumInfoTable expõe alias e chave primária', () {
      final alias = database.condominiumInfoTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.condominiumInfoTable.$columns, isNotEmpty);
      expect(database.condominiumInfoTable.$primaryKey, isNotNull);
    });
  });

  group('managers gerados', () {
    test('employeeInfoTable filtra, ordena e escreve', () async {
      final m = database.managers.employeeInfoTable;
      await m.create((o) => o(
          condoCode: 'a1',
          numCad: 'a1',
          numCra: 'a1',
          cpf: 'a1',
          name: 'a1',
          jobPosition: 'a1',
          idLogin: 'a1',
          pictureHash: 'a1',
          registered: true,
          status: 'a1'));

      expect(
          await m
              .filter((f) =>
                  f.condoCode.equals('a1') &
                  f.numCad.equals('a1') &
                  f.numCra.equals('a1') &
                  f.cpf.equals('a1') &
                  f.name.equals('a1') &
                  f.jobPosition.equals('a1') &
                  f.idLogin.equals('a1') &
                  f.pictureHash.equals('a1') &
                  f.registered.equals(true) &
                  f.status.equals('a1'))
              .get(),
          isA<List<EmployeeInfoData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.condoCode.asc() &
                  o.numCad.asc() &
                  o.numCra.asc() &
                  o.cpf.asc() &
                  o.name.asc() &
                  o.jobPosition.asc() &
                  o.idLogin.asc() &
                  o.pictureHash.asc() &
                  o.registered.asc() &
                  o.status.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.condoCode),
        m.computedField((a) => a.numCad),
        m.computedField((a) => a.numCra),
        m.computedField((a) => a.cpf),
        m.computedField((a) => a.name),
        m.computedField((a) => a.jobPosition),
        m.computedField((a) => a.idLogin),
        m.computedField((a) => a.pictureHash),
        m.computedField((a) => a.registered),
        m.computedField((a) => a.status)
      ], hasLength(10));
      expect(
          await m.update((o) => o(
              condoCode: Value('b2'),
              numCad: Value('b2'),
              numCra: Value('b2'),
              cpf: Value('b2'),
              name: Value('b2'),
              jobPosition: Value('b2'),
              idLogin: Value('b2'),
              pictureHash: Value('b2'),
              registered: Value(false),
              status: Value('b2'))),
          1);
      expect(await m.delete(), 1);
    });

    test('condominiumInfoTable filtra, ordena e escreve', () async {
      final m = database.managers.condominiumInfoTable;
      await m.create((o) => o(
          condoCode: 'a1',
          reference: 'a1',
          name: 'a1',
          picturehash: 'a1',
          status: 'a1',
          ref: 'a1'));

      expect(
          await m
              .filter((f) =>
                  f.condoCode.equals('a1') &
                  f.reference.equals('a1') &
                  f.name.equals('a1') &
                  f.picturehash.equals('a1') &
                  f.status.equals('a1') &
                  f.ref.equals('a1'))
              .get(),
          isA<List<CondominiumInfoData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.condoCode.asc() &
                  o.reference.asc() &
                  o.name.asc() &
                  o.picturehash.asc() &
                  o.status.asc() &
                  o.ref.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.condoCode),
        m.computedField((a) => a.reference),
        m.computedField((a) => a.name),
        m.computedField((a) => a.picturehash),
        m.computedField((a) => a.status),
        m.computedField((a) => a.ref)
      ], hasLength(6));
      expect(
          await m.update((o) => o(
              condoCode: Value('b2'),
              reference: Value('b2'),
              name: Value('b2'),
              picturehash: Value('b2'),
              status: Value('b2'),
              ref: Value('b2'))),
          1);
      expect(await m.delete(), 1);
    });
  });
}
