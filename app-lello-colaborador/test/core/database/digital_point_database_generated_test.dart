// Testes do código gerado pelo drift: cada data class, companion e
// manager é exercitado (json, cópia, igualdade, filtros e ordenação).
import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/init_sqflite_ffi.dart';

void main() {
  initSqfliteForTests();

  late DigitalPointDatabase database;

  setUp(() async {
    database = DigitalPointDatabase();
    await database.resetDb();
  });

  tearDown(() => database.close());

  group('DigitalPointData', () {
    final completo = DigitalPointData(
        id: 1,
        meId: 'a1',
        condominiumId: 'a1',
        date: DateTime(2026, 1, 10, 8),
        latitude: 'a1',
        longitude: 'a1',
        typePoint: 'a1',
        photoTempHash: 'a1',
        photoPath: 'a1',
        status: 'a1',
        captureType: 'a1',
        uniqueHash: 'a1',
        tabletSession: true,
        reference: 'a1',
        numCra: 'a1',
        numCad: 'a1');
    final outro = DigitalPointData(
        id: 2,
        meId: 'b2',
        condominiumId: 'b2',
        date: DateTime(2026, 2, 11, 9),
        latitude: 'b2',
        longitude: 'b2',
        typePoint: 'b2',
        photoTempHash: 'b2',
        photoPath: 'b2',
        status: 'b2',
        captureType: 'b2',
        uniqueHash: 'b2',
        tabletSession: false,
        reference: 'b2',
        numCra: 'b2',
        numCad: 'b2');
    final semOpcionais = DigitalPointData(
        id: 1,
        meId: 'a1',
        condominiumId: 'a1',
        date: DateTime(2026, 1, 10, 8),
        latitude: 'a1',
        longitude: 'a1',
        typePoint: 'a1',
        photoPath: 'a1',
        status: 'a1',
        captureType: 'a1',
        uniqueHash: 'a1',
        tabletSession: true);

    test('json de ida e volta preserva os dados', () {
      expect(DigitalPointData.fromJson(completo.toJson()), completo);
      expect(DigitalPointData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          DigitalPointData(
              id: 1,
              meId: 'a1',
              condominiumId: 'a1',
              date: DateTime(2026, 1, 10, 8),
              latitude: 'a1',
              longitude: 'a1',
              typePoint: 'a1',
              photoTempHash: 'a1',
              photoPath: 'a1',
              status: 'a1',
              captureType: 'a1',
              uniqueHash: 'a1',
              tabletSession: true,
              reference: 'a1',
              numCra: 'a1',
              numCad: 'a1'));
      expect(
          completo.hashCode,
          DigitalPointData(
                  id: 1,
                  meId: 'a1',
                  condominiumId: 'a1',
                  date: DateTime(2026, 1, 10, 8),
                  latitude: 'a1',
                  longitude: 'a1',
                  typePoint: 'a1',
                  photoTempHash: 'a1',
                  photoPath: 'a1',
                  status: 'a1',
                  captureType: 'a1',
                  uniqueHash: 'a1',
                  tabletSession: true,
                  reference: 'a1',
                  numCra: 'a1',
                  numCad: 'a1')
              .hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('DigitalPointData('));
      expect(completo.toString(), contains('id'));
      expect(completo.toString(), contains('meId'));
      expect(completo.toString(), contains('condominiumId'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              id: 2,
              meId: 'b2',
              condominiumId: 'b2',
              date: DateTime(2026, 2, 11, 9),
              latitude: 'b2',
              longitude: 'b2',
              typePoint: 'b2',
              photoTempHash: Value('b2'),
              photoPath: 'b2',
              status: 'b2',
              captureType: 'b2',
              uniqueHash: 'b2',
              tabletSession: false,
              reference: Value('b2'),
              numCra: Value('b2'),
              numCad: Value('b2')),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(DigitalPointTableCompanion(
            id: Value(2),
            meId: Value('b2'),
            condominiumId: Value('b2'),
            date: Value(DateTime(2026, 2, 11, 9)),
            latitude: Value('b2'),
            longitude: Value('b2'),
            typePoint: Value('b2'),
            photoTempHash: Value('b2'),
            photoPath: Value('b2'),
            status: Value('b2'),
            captureType: Value('b2'),
            uniqueHash: Value('b2'),
            tabletSession: Value(false),
            reference: Value('b2'),
            numCra: Value('b2'),
            numCad: Value('b2'))),
        outro,
      );
      expect(completo.copyWithCompanion(const DigitalPointTableCompanion()),
          completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).id.value, 1);
      expect(semOpcionais.toCompanion(true).photoTempHash.present, isFalse);
      expect(semOpcionais.toCompanion(false).photoTempHash.present, isTrue);
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
      expect(semOpcionais.toColumns(true).length,
          lessThan(completo.toColumns(true).length));
    });
  });

  group('DigitalPointTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = DigitalPointTableCompanion.insert(
          id: Value(1),
          meId: 'a1',
          condominiumId: 'a1',
          date: DateTime(2026, 1, 10, 8),
          latitude: 'a1',
          longitude: 'a1',
          typePoint: 'a1',
          photoTempHash: Value('a1'),
          photoPath: 'a1',
          status: 'a1',
          captureType: 'a1',
          uniqueHash: 'a1',
          tabletSession: Value(true),
          reference: Value('a1'),
          numCra: Value('a1'),
          numCad: Value('a1'));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('DigitalPointTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const DigitalPointTableCompanion().copyWith(
          id: Value(2),
          meId: Value('b2'),
          condominiumId: Value('b2'),
          date: Value(DateTime(2026, 2, 11, 9)),
          latitude: Value('b2'),
          longitude: Value('b2'),
          typePoint: Value('b2'),
          photoTempHash: Value('b2'),
          photoPath: Value('b2'),
          status: Value('b2'),
          captureType: Value('b2'),
          uniqueHash: Value('b2'),
          tabletSession: Value(false),
          reference: Value('b2'),
          numCra: Value('b2'),
          numCad: Value('b2'));
      expect(companion.id.value, 2);
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const DigitalPointTableCompanion().copyWith(
          id: Value(2),
          meId: Value('b2'),
          condominiumId: Value('b2'),
          date: Value(DateTime(2026, 2, 11, 9)),
          latitude: Value('b2'),
          longitude: Value('b2'),
          typePoint: Value('b2'),
          photoTempHash: Value('b2'),
          photoPath: Value('b2'),
          status: Value('b2'),
          captureType: Value('b2'),
          uniqueHash: Value('b2'),
          tabletSession: Value(false),
          reference: Value('b2'),
          numCra: Value('b2'),
          numCad: Value('b2'));
      expect(original.copyWith().id.value, 2);
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        DigitalPointTableCompanion.custom(
            id: Variable<int>(1),
            meId: Variable<String>('a1'),
            condominiumId: Variable<String>('a1'),
            date: Variable<DateTime>(DateTime(2026, 1, 10, 8)),
            latitude: Variable<String>('a1'),
            longitude: Variable<String>('a1'),
            typePoint: Variable<String>('a1'),
            photoTempHash: Variable<String>('a1'),
            photoPath: Variable<String>('a1'),
            status: Variable<String>('a1'),
            captureType: Variable<String>('a1'),
            uniqueHash: Variable<String>('a1'),
            tabletSession: Variable<bool>(true),
            reference: Variable<String>('a1'),
            numCra: Variable<String>('a1'),
            numCad: Variable<String>('a1')),
        isA<Insertable<DigitalPointData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const DigitalPointTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('DigitalPointLogData', () {
    final completo = DigitalPointLogData(
        id: 1,
        digitalPointId: 1,
        date: DateTime(2026, 1, 10, 8),
        statusPrevious: 'a1',
        statusNew: 'a1',
        description: 'a1');
    final outro = DigitalPointLogData(
        id: 2,
        digitalPointId: 2,
        date: DateTime(2026, 2, 11, 9),
        statusPrevious: 'b2',
        statusNew: 'b2',
        description: 'b2');

    test('json de ida e volta preserva os dados', () {
      expect(DigitalPointLogData.fromJson(completo.toJson()), completo);
    });

    test('igualdade, hashCode e toString', () {
      expect(
          completo,
          DigitalPointLogData(
              id: 1,
              digitalPointId: 1,
              date: DateTime(2026, 1, 10, 8),
              statusPrevious: 'a1',
              statusNew: 'a1',
              description: 'a1'));
      expect(
          completo.hashCode,
          DigitalPointLogData(
                  id: 1,
                  digitalPointId: 1,
                  date: DateTime(2026, 1, 10, 8),
                  statusPrevious: 'a1',
                  statusNew: 'a1',
                  description: 'a1')
              .hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('DigitalPointLogData('));
      expect(completo.toString(), contains('id'));
      expect(completo.toString(), contains('digitalPointId'));
      expect(completo.toString(), contains('date'));
    });

    test('copyWith troca todos os campos', () {
      expect(
          completo.copyWith(
              id: 2,
              digitalPointId: 2,
              date: DateTime(2026, 2, 11, 9),
              statusPrevious: 'b2',
              statusNew: 'b2',
              description: 'b2'),
          outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(
        completo.copyWithCompanion(DigitalPointLogTableCompanion(
            id: Value(2),
            digitalPointId: Value(2),
            date: Value(DateTime(2026, 2, 11, 9)),
            statusPrevious: Value('b2'),
            statusNew: Value('b2'),
            description: Value('b2'))),
        outro,
      );
      expect(completo.copyWithCompanion(const DigitalPointLogTableCompanion()),
          completo);
    });

    test('toCompanion respeita nullToAbsent', () {
      expect(completo.toCompanion(true).id.value, 1);
    });

    test('toColumns monta as expressões de escrita', () {
      final colunas = completo.toColumns(false);
      expect(colunas, isNotEmpty);
    });
  });

  group('DigitalPointLogTableCompanion', () {
    test('insert preenche as colunas informadas', () {
      final companion = DigitalPointLogTableCompanion.insert(
          id: Value(1),
          digitalPointId: 1,
          date: DateTime(2026, 1, 10, 8),
          statusPrevious: 'a1',
          statusNew: 'a1',
          description: 'a1');
      expect(companion.toColumns(false), isNotEmpty);
      expect(
          companion.toString(), startsWith('DigitalPointLogTableCompanion('));
    });

    test('copyWith substitui os valores', () {
      final companion = const DigitalPointLogTableCompanion().copyWith(
          id: Value(2),
          digitalPointId: Value(2),
          date: Value(DateTime(2026, 2, 11, 9)),
          statusPrevious: Value('b2'),
          statusNew: Value('b2'),
          description: Value('b2'));
      expect(companion.id.value, 2);
    });

    test('copyWith sem argumentos mantém os valores', () {
      final original = const DigitalPointLogTableCompanion().copyWith(
          id: Value(2),
          digitalPointId: Value(2),
          date: Value(DateTime(2026, 2, 11, 9)),
          statusPrevious: Value('b2'),
          statusNew: Value('b2'),
          description: Value('b2'));
      expect(original.copyWith().id.value, 2);
    });

    test('custom monta um insertable a partir de expressões', () {
      expect(
        DigitalPointLogTableCompanion.custom(
            id: Variable<int>(1),
            digitalPointId: Variable<int>(1),
            date: Variable<DateTime>(DateTime(2026, 1, 10, 8)),
            statusPrevious: Variable<String>('a1'),
            statusNew: Variable<String>('a1'),
            description: Variable<String>('a1')),
        isA<Insertable<DigitalPointLogData>>(),
      );
    });

    test('companion vazio não escreve colunas', () {
      expect(const DigitalPointLogTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('escrita direta nas tabelas', () {
    test('digitalPointTable aceita um companion completo', () async {
      await database.into(database.digitalPointTable).insert(
            DigitalPointTableCompanion.insert(
                id: Value(1),
                meId: 'a1',
                condominiumId: 'a1',
                date: DateTime(2026, 1, 10, 8),
                latitude: 'a1',
                longitude: 'a1',
                typePoint: 'a1',
                photoTempHash: Value('a1'),
                photoPath: 'a1',
                status: 'a1',
                captureType: 'a1',
                uniqueHash: 'a1',
                tabletSession: Value(true),
                reference: Value('a1'),
                numCra: Value('a1'),
                numCad: Value('a1')),
          );

      expect(await database.select(database.digitalPointTable).get(),
          hasLength(1));
    });

    test('digitalPointTable recusa companion sem os campos obrigatórios', () {
      expect(
        () => database
            .into(database.digitalPointTable)
            .insert(const DigitalPointTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });

    test('digitalPointLogTable aceita um companion completo', () async {
      await database.into(database.digitalPointLogTable).insert(
            DigitalPointLogTableCompanion.insert(
                id: Value(1),
                digitalPointId: 1,
                date: DateTime(2026, 1, 10, 8),
                statusPrevious: 'a1',
                statusNew: 'a1',
                description: 'a1'),
          );

      expect(await database.select(database.digitalPointLogTable).get(),
          hasLength(1));
    });

    test('digitalPointLogTable recusa companion sem os campos obrigatórios',
        () {
      expect(
        () => database
            .into(database.digitalPointLogTable)
            .insert(const DigitalPointLogTableCompanion()),
        throwsA(isA<InvalidDataException>()),
      );
    });
  });

  group('tabelas geradas', () {
    test('digitalPointTable expõe alias e chave primária', () {
      final alias = database.digitalPointTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.digitalPointTable.$columns, isNotEmpty);
      expect(database.digitalPointTable.$primaryKey, isNotNull);
    });

    test('digitalPointLogTable expõe alias e chave primária', () {
      final alias = database.digitalPointLogTable.createAlias('t');
      expect(alias.aliasedName, 't');
      expect(database.digitalPointLogTable.$columns, isNotEmpty);
      expect(database.digitalPointLogTable.$primaryKey, isNotNull);
    });
  });

  group('managers gerados', () {
    test('digitalPointTable filtra, ordena e escreve', () async {
      final m = database.managers.digitalPointTable;
      await m.create((o) => o(
          meId: 'a1',
          condominiumId: 'a1',
          date: DateTime(2026, 1, 10, 8),
          latitude: 'a1',
          longitude: 'a1',
          typePoint: 'a1',
          photoPath: 'a1',
          status: 'a1',
          captureType: 'a1',
          uniqueHash: 'a1'));

      expect(
          await m
              .filter((f) =>
                  f.id.equals(1) &
                  f.meId.equals('a1') &
                  f.condominiumId.equals('a1') &
                  f.date.equals(DateTime(2026, 1, 10, 8)) &
                  f.latitude.equals('a1') &
                  f.longitude.equals('a1') &
                  f.typePoint.equals('a1') &
                  f.photoTempHash.equals('a1') &
                  f.photoPath.equals('a1') &
                  f.status.equals('a1') &
                  f.captureType.equals('a1') &
                  f.uniqueHash.equals('a1') &
                  f.tabletSession.equals(true) &
                  f.reference.equals('a1') &
                  f.numCra.equals('a1') &
                  f.numCad.equals('a1'))
              .get(),
          isA<List<DigitalPointData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.id.asc() &
                  o.meId.asc() &
                  o.condominiumId.asc() &
                  o.date.asc() &
                  o.latitude.asc() &
                  o.longitude.asc() &
                  o.typePoint.asc() &
                  o.photoTempHash.asc() &
                  o.photoPath.asc() &
                  o.status.asc() &
                  o.captureType.asc() &
                  o.uniqueHash.asc() &
                  o.tabletSession.asc() &
                  o.reference.asc() &
                  o.numCra.asc() &
                  o.numCad.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.meId),
        m.computedField((a) => a.condominiumId),
        m.computedField((a) => a.date),
        m.computedField((a) => a.latitude),
        m.computedField((a) => a.longitude),
        m.computedField((a) => a.typePoint),
        m.computedField((a) => a.photoTempHash),
        m.computedField((a) => a.photoPath),
        m.computedField((a) => a.status),
        m.computedField((a) => a.captureType),
        m.computedField((a) => a.uniqueHash),
        m.computedField((a) => a.tabletSession),
        m.computedField((a) => a.reference),
        m.computedField((a) => a.numCra),
        m.computedField((a) => a.numCad)
      ], hasLength(16));
      expect(
          await m.update((o) => o(
              id: Value(2),
              meId: Value('b2'),
              condominiumId: Value('b2'),
              date: Value(DateTime(2026, 2, 11, 9)),
              latitude: Value('b2'),
              longitude: Value('b2'),
              typePoint: Value('b2'),
              photoTempHash: Value('b2'),
              photoPath: Value('b2'),
              status: Value('b2'),
              captureType: Value('b2'),
              uniqueHash: Value('b2'),
              tabletSession: Value(false),
              reference: Value('b2'),
              numCra: Value('b2'),
              numCad: Value('b2'))),
          1);
      expect(await m.delete(), 1);
    });

    test('digitalPointLogTable filtra, ordena e escreve', () async {
      final m = database.managers.digitalPointLogTable;
      await m.create((o) => o(
          digitalPointId: 1,
          date: DateTime(2026, 1, 10, 8),
          statusPrevious: 'a1',
          statusNew: 'a1',
          description: 'a1'));

      expect(
          await m
              .filter((f) =>
                  f.id.equals(1) &
                  f.digitalPointId.equals(1) &
                  f.date.equals(DateTime(2026, 1, 10, 8)) &
                  f.statusPrevious.equals('a1') &
                  f.statusNew.equals('a1') &
                  f.description.equals('a1'))
              .get(),
          isA<List<DigitalPointLogData>>());
      expect(
          await m
              .orderBy((o) =>
                  o.id.asc() &
                  o.digitalPointId.asc() &
                  o.date.asc() &
                  o.statusPrevious.asc() &
                  o.statusNew.asc() &
                  o.description.asc())
              .get(),
          hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.digitalPointId),
        m.computedField((a) => a.date),
        m.computedField((a) => a.statusPrevious),
        m.computedField((a) => a.statusNew),
        m.computedField((a) => a.description)
      ], hasLength(6));
      expect(
          await m.update((o) => o(
              id: Value(2),
              digitalPointId: Value(2),
              date: Value(DateTime(2026, 2, 11, 9)),
              statusPrevious: Value('b2'),
              statusNew: Value('b2'),
              description: Value('b2'))),
          1);
      expect(await m.delete(), 1);
    });
  });
}
