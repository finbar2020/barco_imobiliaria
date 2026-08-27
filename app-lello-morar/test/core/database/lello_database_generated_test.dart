// Testes do código gerado pelo drift: cada data class, companion e
// manager é exercitado (json, cópia, igualdade, filtros e ordenação).
// Arquivo gerado por script; ajuste o gerador em vez de editar à mão.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/database/lello_database.dart';

import '../../helpers/init_sqflite_ffi.dart';

void main() {
  initSqfliteForTests();

  late LelloDatabase database;

  setUp(() async {
    database = LelloDatabase();
    await database.resetDb();
  });

  tearDown(() => database.close());

  group('MeData', () {
    final completo = MeData(id: 'a1', name: 'a1', email: 'a1', cpf: 'a1', phone: 'a1', picture: 'a1', pictureHash: 'a1', biometricPictureHash: 'a1', useFacialBiometric: true, updated: DateTime(2026, 1, 10, 8));
    final outro = MeData(id: 'b2', name: 'b2', email: 'b2', cpf: 'b2', phone: 'b2', picture: 'b2', pictureHash: 'b2', biometricPictureHash: 'b2', useFacialBiometric: false, updated: DateTime(2026, 2, 11, 9));
    final semOpcionais = MeData(name: 'a1', email: 'a1', picture: 'a1', updated: DateTime(2026, 1, 10, 8));

    test('json de ida e volta preserva os dados', () {
      expect(MeData.fromJson(completo.toJson()), completo);
      expect(MeData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(completo, MeData(id: 'a1', name: 'a1', email: 'a1', cpf: 'a1', phone: 'a1', picture: 'a1', pictureHash: 'a1', biometricPictureHash: 'a1', useFacialBiometric: true, updated: DateTime(2026, 1, 10, 8)));
      expect(completo.hashCode, MeData(id: 'a1', name: 'a1', email: 'a1', cpf: 'a1', phone: 'a1', picture: 'a1', pictureHash: 'a1', biometricPictureHash: 'a1', useFacialBiometric: true, updated: DateTime(2026, 1, 10, 8)).hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('MeData('));
    });

    test('copyWith troca todos os campos', () {
      expect(completo.copyWith(id: Value('b2'), name: 'b2', email: 'b2', cpf: Value('b2'), phone: Value('b2'), picture: 'b2', pictureHash: Value('b2'), biometricPictureHash: Value('b2'), useFacialBiometric: Value(false), updated: DateTime(2026, 2, 11, 9)), outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(completo.copyWithCompanion(MeTableCompanion(id: Value('b2'), name: Value('b2'), email: Value('b2'), cpf: Value('b2'), phone: Value('b2'), picture: Value('b2'), pictureHash: Value('b2'), biometricPictureHash: Value('b2'), useFacialBiometric: Value(false), updated: Value(DateTime(2026, 2, 11, 9)))), outro);
      expect(completo.copyWithCompanion(const MeTableCompanion()), completo);
    });

    test('toCompanion e toColumns', () {
      expect(completo.toCompanion(true).id.value, 'a1');
      expect(semOpcionais.toCompanion(true).id.present, isFalse);
      expect(semOpcionais.toCompanion(false).id.present, isTrue);
      expect(completo.toColumns(false), isNotEmpty);
      expect(semOpcionais.toColumns(true).length, lessThanOrEqualTo(completo.toColumns(true).length));
    });
  });

  group('MeTableCompanion', () {
    test('insert, copyWith, custom e vazio', () {
      final companion = MeTableCompanion.insert(id: Value('a1'), name: 'a1', email: 'a1', cpf: Value('a1'), phone: Value('a1'), picture: 'a1', pictureHash: Value('a1'), biometricPictureHash: Value('a1'), useFacialBiometric: Value(true), updated: DateTime(2026, 1, 10, 8));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('MeTableCompanion('));
      final copiado = const MeTableCompanion().copyWith(id: Value('b2'), name: Value('b2'), email: Value('b2'), cpf: Value('b2'), phone: Value('b2'), picture: Value('b2'), pictureHash: Value('b2'), biometricPictureHash: Value('b2'), useFacialBiometric: Value(false), updated: Value(DateTime(2026, 2, 11, 9)), rowid: Value(2));
      expect(copiado.id.value, 'b2');
      expect(copiado.copyWith().id.value, 'b2');
      expect(MeTableCompanion.custom(id: Variable<String>('a1'), name: Variable<String>('a1'), email: Variable<String>('a1'), cpf: Variable<String>('a1'), phone: Variable<String>('a1'), picture: Variable<String>('a1'), pictureHash: Variable<String>('a1'), biometricPictureHash: Variable<String>('a1'), useFacialBiometric: Variable<bool>(true), updated: Variable<DateTime>(DateTime(2026, 1, 10, 8)), rowid: Variable<int>(1)), isA<Insertable<MeData>>());
      expect(const MeTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('manager meTable', () {
    test('filtra, ordena e escreve', () async {
      final m = database.managers.meTable;
      await m.create((o) => o(id: Value('a1'), name: 'a1', email: 'a1', cpf: Value('a1'), phone: Value('a1'), picture: 'a1', pictureHash: Value('a1'), biometricPictureHash: Value('a1'), useFacialBiometric: Value(true), updated: DateTime(2026, 1, 10, 8)));
      expect(await m.filter((f) => f.id.equals('a1') &
              f.name.equals('a1') &
              f.email.equals('a1') &
              f.cpf.equals('a1') &
              f.phone.equals('a1') &
              f.picture.equals('a1') &
              f.pictureHash.equals('a1') &
              f.biometricPictureHash.equals('a1') &
              f.useFacialBiometric.equals(true) &
              f.updated.equals(DateTime(2026, 1, 10, 8))).get(), hasLength(1));
      expect(await m.orderBy((o) => o.id.asc() &
              o.name.asc() &
              o.email.asc() &
              o.cpf.asc() &
              o.phone.asc() &
              o.picture.asc() &
              o.pictureHash.asc() &
              o.biometricPictureHash.asc() &
              o.useFacialBiometric.asc() &
              o.updated.asc()).get(), hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.name),
        m.computedField((a) => a.email),
        m.computedField((a) => a.cpf),
        m.computedField((a) => a.phone),
        m.computedField((a) => a.picture),
        m.computedField((a) => a.pictureHash),
        m.computedField((a) => a.biometricPictureHash),
        m.computedField((a) => a.useFacialBiometric),
        m.computedField((a) => a.updated)
      ], hasLength(10));
      expect(await m.update((o) => o(id: Value('b2'), name: Value('b2'), email: Value('b2'), cpf: Value('b2'), phone: Value('b2'), picture: Value('b2'), pictureHash: Value('b2'), biometricPictureHash: Value('b2'), useFacialBiometric: Value(false), updated: Value(DateTime(2026, 2, 11, 9)))), 1);
      expect(await m.delete(), 1);
    });
  });

  group('CondominiumData', () {
    final completo = CondominiumData(id: 'a1', reference: 'a1', name: 'a1', address: 'a1', regulationUrl: 'a1', active_manager: true);
    final outro = CondominiumData(id: 'b2', reference: 'b2', name: 'b2', address: 'b2', regulationUrl: 'b2', active_manager: false);
    final semOpcionais = CondominiumData(id: 'a1', regulationUrl: 'a1');

    test('json de ida e volta preserva os dados', () {
      expect(CondominiumData.fromJson(completo.toJson()), completo);
      expect(CondominiumData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(completo, CondominiumData(id: 'a1', reference: 'a1', name: 'a1', address: 'a1', regulationUrl: 'a1', active_manager: true));
      expect(completo.hashCode, CondominiumData(id: 'a1', reference: 'a1', name: 'a1', address: 'a1', regulationUrl: 'a1', active_manager: true).hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('CondominiumData('));
    });

    test('copyWith troca todos os campos', () {
      expect(completo.copyWith(id: 'b2', reference: Value('b2'), name: Value('b2'), address: Value('b2'), regulationUrl: 'b2', active_manager: Value(false)), outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(completo.copyWithCompanion(CondominiumTableCompanion(id: Value('b2'), reference: Value('b2'), name: Value('b2'), address: Value('b2'), regulationUrl: Value('b2'), active_manager: Value(false))), outro);
      expect(completo.copyWithCompanion(const CondominiumTableCompanion()), completo);
    });

    test('toCompanion e toColumns', () {
      expect(completo.toCompanion(true).id.value, 'a1');
      expect(semOpcionais.toCompanion(true).reference.present, isFalse);
      expect(semOpcionais.toCompanion(false).reference.present, isTrue);
      expect(completo.toColumns(false), isNotEmpty);
      expect(semOpcionais.toColumns(true).length, lessThanOrEqualTo(completo.toColumns(true).length));
    });
  });

  group('CondominiumTableCompanion', () {
    test('insert, copyWith, custom e vazio', () {
      final companion = CondominiumTableCompanion.insert(id: 'a1', reference: Value('a1'), name: Value('a1'), address: Value('a1'), regulationUrl: 'a1', active_manager: Value(true));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('CondominiumTableCompanion('));
      final copiado = const CondominiumTableCompanion().copyWith(id: Value('b2'), reference: Value('b2'), name: Value('b2'), address: Value('b2'), regulationUrl: Value('b2'), active_manager: Value(false), rowid: Value(2));
      expect(copiado.id.value, 'b2');
      expect(copiado.copyWith().id.value, 'b2');
      expect(CondominiumTableCompanion.custom(id: Variable<String>('a1'), reference: Variable<String>('a1'), name: Variable<String>('a1'), address: Variable<String>('a1'), regulationUrl: Variable<String>('a1'), active_manager: Variable<bool>(true), rowid: Variable<int>(1)), isA<Insertable<CondominiumData>>());
      expect(const CondominiumTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('manager condominiumTable', () {
    test('filtra, ordena e escreve', () async {
      final m = database.managers.condominiumTable;
      await m.create((o) => o(id: 'a1', reference: Value('a1'), name: Value('a1'), address: Value('a1'), regulationUrl: 'a1', active_manager: Value(true)));
      expect(await m.filter((f) => f.id.equals('a1') &
              f.reference.equals('a1') &
              f.name.equals('a1') &
              f.address.equals('a1') &
              f.regulationUrl.equals('a1') &
              f.active_manager.equals(true)).get(), hasLength(1));
      expect(await m.orderBy((o) => o.id.asc() &
              o.reference.asc() &
              o.name.asc() &
              o.address.asc() &
              o.regulationUrl.asc() &
              o.active_manager.asc()).get(), hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.reference),
        m.computedField((a) => a.name),
        m.computedField((a) => a.address),
        m.computedField((a) => a.regulationUrl),
        m.computedField((a) => a.active_manager)
      ], hasLength(6));
      expect(await m.update((o) => o(id: Value('b2'), reference: Value('b2'), name: Value('b2'), address: Value('b2'), regulationUrl: Value('b2'), active_manager: Value(false))), 1);
      expect(await m.delete(), 1);
    });
  });

  group('BlockData', () {
    final completo = BlockData(id: 'a1', condominiumId: 'a1', name: 'a1');
    final outro = BlockData(id: 'b2', condominiumId: 'b2', name: 'b2');
    final semOpcionais = BlockData(id: 'a1', condominiumId: 'a1');

    test('json de ida e volta preserva os dados', () {
      expect(BlockData.fromJson(completo.toJson()), completo);
      expect(BlockData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(completo, BlockData(id: 'a1', condominiumId: 'a1', name: 'a1'));
      expect(completo.hashCode, BlockData(id: 'a1', condominiumId: 'a1', name: 'a1').hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('BlockData('));
    });

    test('copyWith troca todos os campos', () {
      expect(completo.copyWith(id: 'b2', condominiumId: 'b2', name: Value('b2')), outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(completo.copyWithCompanion(BlockTableCompanion(id: Value('b2'), condominiumId: Value('b2'), name: Value('b2'))), outro);
      expect(completo.copyWithCompanion(const BlockTableCompanion()), completo);
    });

    test('toCompanion e toColumns', () {
      expect(completo.toCompanion(true).id.value, 'a1');
      expect(semOpcionais.toCompanion(true).name.present, isFalse);
      expect(semOpcionais.toCompanion(false).name.present, isTrue);
      expect(completo.toColumns(false), isNotEmpty);
      expect(semOpcionais.toColumns(true).length, lessThanOrEqualTo(completo.toColumns(true).length));
    });
  });

  group('BlockTableCompanion', () {
    test('insert, copyWith, custom e vazio', () {
      final companion = BlockTableCompanion.insert(id: 'a1', condominiumId: 'a1', name: Value('a1'));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('BlockTableCompanion('));
      final copiado = const BlockTableCompanion().copyWith(id: Value('b2'), condominiumId: Value('b2'), name: Value('b2'), rowid: Value(2));
      expect(copiado.id.value, 'b2');
      expect(copiado.copyWith().id.value, 'b2');
      expect(BlockTableCompanion.custom(id: Variable<String>('a1'), condominiumId: Variable<String>('a1'), name: Variable<String>('a1'), rowid: Variable<int>(1)), isA<Insertable<BlockData>>());
      expect(const BlockTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('manager blockTable', () {
    test('filtra, ordena e escreve', () async {
      final m = database.managers.blockTable;
      await m.create((o) => o(id: 'a1', condominiumId: 'a1', name: Value('a1')));
      expect(await m.filter((f) => f.id.equals('a1') &
              f.condominiumId.equals('a1') &
              f.name.equals('a1')).get(), hasLength(1));
      expect(await m.orderBy((o) => o.id.asc() &
              o.condominiumId.asc() &
              o.name.asc()).get(), hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.condominiumId),
        m.computedField((a) => a.name)
      ], hasLength(3));
      expect(await m.update((o) => o(id: Value('b2'), condominiumId: Value('b2'), name: Value('b2'))), 1);
      expect(await m.delete(), 1);
    });
  });

  group('UnitData', () {
    final completo = UnitData(id: 'a1', notificationContext: 'a1', blockId: 'a1', title: 'a1', rented: true, compliant: true, agreement: true, termHomeToGo: true);
    final outro = UnitData(id: 'b2', notificationContext: 'b2', blockId: 'b2', title: 'b2', rented: false, compliant: false, agreement: false, termHomeToGo: false);
    final semOpcionais = UnitData(id: 'a1', notificationContext: 'a1', blockId: 'a1');

    test('json de ida e volta preserva os dados', () {
      expect(UnitData.fromJson(completo.toJson()), completo);
      expect(UnitData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(completo, UnitData(id: 'a1', notificationContext: 'a1', blockId: 'a1', title: 'a1', rented: true, compliant: true, agreement: true, termHomeToGo: true));
      expect(completo.hashCode, UnitData(id: 'a1', notificationContext: 'a1', blockId: 'a1', title: 'a1', rented: true, compliant: true, agreement: true, termHomeToGo: true).hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('UnitData('));
    });

    test('copyWith troca todos os campos', () {
      expect(completo.copyWith(id: 'b2', notificationContext: 'b2', blockId: 'b2', title: Value('b2'), rented: Value(false), compliant: Value(false), agreement: Value(false), termHomeToGo: Value(false)), outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(completo.copyWithCompanion(UnitTableCompanion(id: Value('b2'), notificationContext: Value('b2'), blockId: Value('b2'), title: Value('b2'), rented: Value(false), compliant: Value(false), agreement: Value(false), termHomeToGo: Value(false))), outro);
      expect(completo.copyWithCompanion(const UnitTableCompanion()), completo);
    });

    test('toCompanion e toColumns', () {
      expect(completo.toCompanion(true).id.value, 'a1');
      expect(semOpcionais.toCompanion(true).title.present, isFalse);
      expect(semOpcionais.toCompanion(false).title.present, isTrue);
      expect(completo.toColumns(false), isNotEmpty);
      expect(semOpcionais.toColumns(true).length, lessThanOrEqualTo(completo.toColumns(true).length));
    });
  });

  group('UnitTableCompanion', () {
    test('insert, copyWith, custom e vazio', () {
      final companion = UnitTableCompanion.insert(id: 'a1', notificationContext: Value('a1'), blockId: 'a1', title: Value('a1'), rented: Value(true), compliant: Value(true), agreement: Value(true), termHomeToGo: Value(true));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('UnitTableCompanion('));
      final copiado = const UnitTableCompanion().copyWith(id: Value('b2'), notificationContext: Value('b2'), blockId: Value('b2'), title: Value('b2'), rented: Value(false), compliant: Value(false), agreement: Value(false), termHomeToGo: Value(false), rowid: Value(2));
      expect(copiado.id.value, 'b2');
      expect(copiado.copyWith().id.value, 'b2');
      expect(UnitTableCompanion.custom(id: Variable<String>('a1'), notificationContext: Variable<String>('a1'), blockId: Variable<String>('a1'), title: Variable<String>('a1'), rented: Variable<bool>(true), compliant: Variable<bool>(true), agreement: Variable<bool>(true), termHomeToGo: Variable<bool>(true), rowid: Variable<int>(1)), isA<Insertable<UnitData>>());
      expect(const UnitTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('manager unitTable', () {
    test('filtra, ordena e escreve', () async {
      final m = database.managers.unitTable;
      await m.create((o) => o(id: 'a1', notificationContext: Value('a1'), blockId: 'a1', title: Value('a1'), rented: Value(true), compliant: Value(true), agreement: Value(true), termHomeToGo: Value(true)));
      expect(await m.filter((f) => f.id.equals('a1') &
              f.notificationContext.equals('a1') &
              f.blockId.equals('a1') &
              f.title.equals('a1') &
              f.rented.equals(true) &
              f.compliant.equals(true) &
              f.agreement.equals(true) &
              f.termHomeToGo.equals(true)).get(), hasLength(1));
      expect(await m.orderBy((o) => o.id.asc() &
              o.notificationContext.asc() &
              o.blockId.asc() &
              o.title.asc() &
              o.rented.asc() &
              o.compliant.asc() &
              o.agreement.asc() &
              o.termHomeToGo.asc()).get(), hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.notificationContext),
        m.computedField((a) => a.blockId),
        m.computedField((a) => a.title),
        m.computedField((a) => a.rented),
        m.computedField((a) => a.compliant),
        m.computedField((a) => a.agreement),
        m.computedField((a) => a.termHomeToGo)
      ], hasLength(8));
      expect(await m.update((o) => o(id: Value('b2'), notificationContext: Value('b2'), blockId: Value('b2'), title: Value('b2'), rented: Value(false), compliant: Value(false), agreement: Value(false), termHomeToGo: Value(false))), 1);
      expect(await m.delete(), 1);
    });
  });

  group('AuthorizationData', () {
    final completo = AuthorizationData(role: 'a1');
    final outro = AuthorizationData(role: 'b2');
    final semOpcionais = AuthorizationData(role: 'a1');

    test('json de ida e volta preserva os dados', () {
      expect(AuthorizationData.fromJson(completo.toJson()), completo);
      expect(AuthorizationData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(completo, AuthorizationData(role: 'a1'));
      expect(completo.hashCode, AuthorizationData(role: 'a1').hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('AuthorizationData('));
    });

    test('copyWith troca todos os campos', () {
      expect(completo.copyWith(role: 'b2'), outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(completo.copyWithCompanion(AuthorizationTableCompanion(role: Value('b2'))), outro);
      expect(completo.copyWithCompanion(const AuthorizationTableCompanion()), completo);
    });

    test('toCompanion e toColumns', () {
      expect(completo.toCompanion(true).role.value, 'a1');
      
      
      expect(completo.toColumns(false), isNotEmpty);
      expect(semOpcionais.toColumns(true).length, lessThanOrEqualTo(completo.toColumns(true).length));
    });
  });

  group('AuthorizationTableCompanion', () {
    test('insert, copyWith, custom e vazio', () {
      final companion = AuthorizationTableCompanion.insert(role: 'a1');
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('AuthorizationTableCompanion('));
      final copiado = const AuthorizationTableCompanion().copyWith(role: Value('b2'), rowid: Value(2));
      expect(copiado.role.value, 'b2');
      expect(copiado.copyWith().role.value, 'b2');
      expect(AuthorizationTableCompanion.custom(role: Variable<String>('a1'), rowid: Variable<int>(1)), isA<Insertable<AuthorizationData>>());
      expect(const AuthorizationTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('manager authorizationTable', () {
    test('filtra, ordena e escreve', () async {
      final m = database.managers.authorizationTable;
      await m.create((o) => o(role: 'a1'));
      expect(await m.filter((f) => f.role.equals('a1')).get(), hasLength(1));
      expect(await m.orderBy((o) => o.role.asc()).get(), hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.role)
      ], hasLength(1));
      expect(await m.update((o) => o(role: Value('b2'))), 1);
      expect(await m.delete(), 1);
    });
  });

  group('LayoutData', () {
    final completo = LayoutData(id: 'a1', condoId: 'a1', cod: 'a1', name: 'a1', reference: 'a1', primary: 'a1', secondary: 'a1', logoPath: 'a1');
    final outro = LayoutData(id: 'b2', condoId: 'b2', cod: 'b2', name: 'b2', reference: 'b2', primary: 'b2', secondary: 'b2', logoPath: 'b2');
    final semOpcionais = LayoutData(id: 'a1', condoId: 'a1');

    test('json de ida e volta preserva os dados', () {
      expect(LayoutData.fromJson(completo.toJson()), completo);
      expect(LayoutData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(completo, LayoutData(id: 'a1', condoId: 'a1', cod: 'a1', name: 'a1', reference: 'a1', primary: 'a1', secondary: 'a1', logoPath: 'a1'));
      expect(completo.hashCode, LayoutData(id: 'a1', condoId: 'a1', cod: 'a1', name: 'a1', reference: 'a1', primary: 'a1', secondary: 'a1', logoPath: 'a1').hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('LayoutData('));
    });

    test('copyWith troca todos os campos', () {
      expect(completo.copyWith(id: 'b2', condoId: 'b2', cod: Value('b2'), name: Value('b2'), reference: Value('b2'), primary: Value('b2'), secondary: Value('b2'), logoPath: Value('b2')), outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(completo.copyWithCompanion(LayoutTableCompanion(id: Value('b2'), condoId: Value('b2'), cod: Value('b2'), name: Value('b2'), reference: Value('b2'), primary: Value('b2'), secondary: Value('b2'), logoPath: Value('b2'))), outro);
      expect(completo.copyWithCompanion(const LayoutTableCompanion()), completo);
    });

    test('toCompanion e toColumns', () {
      expect(completo.toCompanion(true).id.value, 'a1');
      expect(semOpcionais.toCompanion(true).cod.present, isFalse);
      expect(semOpcionais.toCompanion(false).cod.present, isTrue);
      expect(completo.toColumns(false), isNotEmpty);
      expect(semOpcionais.toColumns(true).length, lessThanOrEqualTo(completo.toColumns(true).length));
    });
  });

  group('LayoutTableCompanion', () {
    test('insert, copyWith, custom e vazio', () {
      final companion = LayoutTableCompanion.insert(id: 'a1', condoId: 'a1', cod: Value('a1'), name: Value('a1'), reference: Value('a1'), primary: Value('a1'), secondary: Value('a1'), logoPath: Value('a1'));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('LayoutTableCompanion('));
      final copiado = const LayoutTableCompanion().copyWith(id: Value('b2'), condoId: Value('b2'), cod: Value('b2'), name: Value('b2'), reference: Value('b2'), primary: Value('b2'), secondary: Value('b2'), logoPath: Value('b2'), rowid: Value(2));
      expect(copiado.id.value, 'b2');
      expect(copiado.copyWith().id.value, 'b2');
      expect(LayoutTableCompanion.custom(id: Variable<String>('a1'), condoId: Variable<String>('a1'), cod: Variable<String>('a1'), name: Variable<String>('a1'), reference: Variable<String>('a1'), primary: Variable<String>('a1'), secondary: Variable<String>('a1'), logoPath: Variable<String>('a1'), rowid: Variable<int>(1)), isA<Insertable<LayoutData>>());
      expect(const LayoutTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('manager layoutTable', () {
    test('filtra, ordena e escreve', () async {
      final m = database.managers.layoutTable;
      await m.create((o) => o(id: 'a1', condoId: 'a1', cod: Value('a1'), name: Value('a1'), reference: Value('a1'), primary: Value('a1'), secondary: Value('a1'), logoPath: Value('a1')));
      expect(await m.filter((f) => f.id.equals('a1') &
              f.condoId.equals('a1') &
              f.cod.equals('a1') &
              f.name.equals('a1') &
              f.reference.equals('a1') &
              f.primary.equals('a1') &
              f.secondary.equals('a1') &
              f.logoPath.equals('a1')).get(), hasLength(1));
      expect(await m.orderBy((o) => o.id.asc() &
              o.condoId.asc() &
              o.cod.asc() &
              o.name.asc() &
              o.reference.asc() &
              o.primary.asc() &
              o.secondary.asc() &
              o.logoPath.asc()).get(), hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.id),
        m.computedField((a) => a.condoId),
        m.computedField((a) => a.cod),
        m.computedField((a) => a.name),
        m.computedField((a) => a.reference),
        m.computedField((a) => a.primary),
        m.computedField((a) => a.secondary),
        m.computedField((a) => a.logoPath)
      ], hasLength(8));
      expect(await m.update((o) => o(id: Value('b2'), condoId: Value('b2'), cod: Value('b2'), name: Value('b2'), reference: Value('b2'), primary: Value('b2'), secondary: Value('b2'), logoPath: Value('b2'))), 1);
      expect(await m.delete(), 1);
    });
  });

  group('CachedDocumentsData', () {
    final completo = CachedDocumentsData(condominiumId: 'a1', unitId: 'a1', documentType: 'a1', documentsJson: 'a1', lastFetchedAt: 1, lastErrorAt: 1);
    final outro = CachedDocumentsData(condominiumId: 'b2', unitId: 'b2', documentType: 'b2', documentsJson: 'b2', lastFetchedAt: 2, lastErrorAt: 2);
    final semOpcionais = CachedDocumentsData(condominiumId: 'a1', unitId: 'a1', documentType: 'a1', documentsJson: 'a1', lastFetchedAt: 1);

    test('json de ida e volta preserva os dados', () {
      expect(CachedDocumentsData.fromJson(completo.toJson()), completo);
      expect(CachedDocumentsData.fromJson(semOpcionais.toJson()), semOpcionais);
    });

    test('igualdade, hashCode e toString', () {
      expect(completo, CachedDocumentsData(condominiumId: 'a1', unitId: 'a1', documentType: 'a1', documentsJson: 'a1', lastFetchedAt: 1, lastErrorAt: 1));
      expect(completo.hashCode, CachedDocumentsData(condominiumId: 'a1', unitId: 'a1', documentType: 'a1', documentsJson: 'a1', lastFetchedAt: 1, lastErrorAt: 1).hashCode);
      expect(completo == outro, isFalse);
      expect(completo.toString(), startsWith('CachedDocumentsData('));
    });

    test('copyWith troca todos os campos', () {
      expect(completo.copyWith(condominiumId: 'b2', unitId: 'b2', documentType: 'b2', documentsJson: 'b2', lastFetchedAt: 2, lastErrorAt: Value(2)), outro);
      expect(completo.copyWith(), completo);
    });

    test('copyWithCompanion aplica só o que está presente', () {
      expect(completo.copyWithCompanion(CachedDocumentsTableCompanion(condominiumId: Value('b2'), unitId: Value('b2'), documentType: Value('b2'), documentsJson: Value('b2'), lastFetchedAt: Value(2), lastErrorAt: Value(2))), outro);
      expect(completo.copyWithCompanion(const CachedDocumentsTableCompanion()), completo);
    });

    test('toCompanion e toColumns', () {
      expect(completo.toCompanion(true).condominiumId.value, 'a1');
      expect(semOpcionais.toCompanion(true).lastErrorAt.present, isFalse);
      expect(semOpcionais.toCompanion(false).lastErrorAt.present, isTrue);
      expect(completo.toColumns(false), isNotEmpty);
      expect(semOpcionais.toColumns(true).length, lessThanOrEqualTo(completo.toColumns(true).length));
    });
  });

  group('CachedDocumentsTableCompanion', () {
    test('insert, copyWith, custom e vazio', () {
      final companion = CachedDocumentsTableCompanion.insert(condominiumId: 'a1', unitId: 'a1', documentType: 'a1', documentsJson: 'a1', lastFetchedAt: 1, lastErrorAt: Value(1));
      expect(companion.toColumns(false), isNotEmpty);
      expect(companion.toString(), startsWith('CachedDocumentsTableCompanion('));
      final copiado = const CachedDocumentsTableCompanion().copyWith(condominiumId: Value('b2'), unitId: Value('b2'), documentType: Value('b2'), documentsJson: Value('b2'), lastFetchedAt: Value(2), lastErrorAt: Value(2), rowid: Value(2));
      expect(copiado.condominiumId.value, 'b2');
      expect(copiado.copyWith().condominiumId.value, 'b2');
      expect(CachedDocumentsTableCompanion.custom(condominiumId: Variable<String>('a1'), unitId: Variable<String>('a1'), documentType: Variable<String>('a1'), documentsJson: Variable<String>('a1'), lastFetchedAt: Variable<int>(1), lastErrorAt: Variable<int>(1), rowid: Variable<int>(1)), isA<Insertable<CachedDocumentsData>>());
      expect(const CachedDocumentsTableCompanion().toColumns(false), isEmpty);
    });
  });

  group('manager cachedDocumentsTable', () {
    test('filtra, ordena e escreve', () async {
      final m = database.managers.cachedDocumentsTable;
      await m.create((o) => o(condominiumId: 'a1', unitId: 'a1', documentType: 'a1', documentsJson: 'a1', lastFetchedAt: 1, lastErrorAt: Value(1)));
      expect(await m.filter((f) => f.condominiumId.equals('a1') &
              f.unitId.equals('a1') &
              f.documentType.equals('a1') &
              f.documentsJson.equals('a1') &
              f.lastFetchedAt.equals(1) &
              f.lastErrorAt.equals(1)).get(), hasLength(1));
      expect(await m.orderBy((o) => o.condominiumId.asc() &
              o.unitId.asc() &
              o.documentType.asc() &
              o.documentsJson.asc() &
              o.lastFetchedAt.asc() &
              o.lastErrorAt.asc()).get(), hasLength(1));
      expect(<Object>[
        m.computedField((a) => a.condominiumId),
        m.computedField((a) => a.unitId),
        m.computedField((a) => a.documentType),
        m.computedField((a) => a.documentsJson),
        m.computedField((a) => a.lastFetchedAt),
        m.computedField((a) => a.lastErrorAt)
      ], hasLength(6));
      expect(await m.update((o) => o(condominiumId: Value('b2'), unitId: Value('b2'), documentType: Value('b2'), documentsJson: Value('b2'), lastFetchedAt: Value(2), lastErrorAt: Value(2))), 1);
      expect(await m.delete(), 1);
    });
  });

  test('tabelas expõem colunas e chaves', () {
    expect(database.meTable.$columns, hasLength(10));
    expect(database.meTable.$primaryKey, isNotEmpty);
    expect(database.meTable.actualTableName, isNotEmpty);
    expect(database.meTable.createAlias('x').aliasedName, 'x');
    expect(database.condominiumTable.$columns, hasLength(6));
    expect(database.condominiumTable.$primaryKey, isNotEmpty);
    expect(database.condominiumTable.actualTableName, isNotEmpty);
    expect(database.condominiumTable.createAlias('x').aliasedName, 'x');
    expect(database.blockTable.$columns, hasLength(3));
    expect(database.blockTable.$primaryKey, isNotEmpty);
    expect(database.blockTable.actualTableName, isNotEmpty);
    expect(database.blockTable.createAlias('x').aliasedName, 'x');
    expect(database.unitTable.$columns, hasLength(8));
    expect(database.unitTable.$primaryKey, isNotEmpty);
    expect(database.unitTable.actualTableName, isNotEmpty);
    expect(database.unitTable.createAlias('x').aliasedName, 'x');
    expect(database.authorizationTable.$columns, hasLength(1));
    expect(database.authorizationTable.$primaryKey, isNotEmpty);
    expect(database.authorizationTable.actualTableName, isNotEmpty);
    expect(database.authorizationTable.createAlias('x').aliasedName, 'x');
    expect(database.layoutTable.$columns, hasLength(8));
    expect(database.layoutTable.$primaryKey, isNotEmpty);
    expect(database.layoutTable.actualTableName, isNotEmpty);
    expect(database.layoutTable.createAlias('x').aliasedName, 'x');
    expect(database.cachedDocumentsTable.$columns, hasLength(6));
    expect(database.cachedDocumentsTable.$primaryKey, isNotEmpty);
    expect(database.cachedDocumentsTable.actualTableName, isNotEmpty);
    expect(database.cachedDocumentsTable.createAlias('x').aliasedName, 'x');
  });
}
