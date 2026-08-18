import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:lello/feature/condominium/data/model/condominium_model.dart';
import 'package:lello/feature/condominium/data/model/layout_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/entity/layout.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';

void main() {
  test('MeModel fromJson/toJson/fromEntity/toEntity', () {
    final parsed = MeModel.fromJson({
      'name': 'Ana',
      'id': '1',
      'email': 'a@b.c',
      'cpf': '123',
      'phone': '11',
      'picture': 'pic',
      'picture_hash': 'h',
      'condominiums': [
        {'id': 'c1', 'reference': 'ref-1', 'name': 'Edifício'},
      ],
    });
    expect(parsed.name, 'Ana');
    expect(parsed.condominiums?.single?.id, 'c1');
    expect(parsed.toJson()['email'], 'a@b.c');

    final entity = parsed.toEntity();
    expect(entity.condominiums?.single.id, 'c1');
    expect(MeModel.fromEntity(entity).cpf, '123');
    expect(parsed.copyWith(name: 'Bia').name, 'Bia');
  });

  test('CondominiumModel fromJson/toEntity/fromEntity', () {
    final parsed = CondominiumModel.fromJson({
      'id': 'c1',
      'reference': 'ref-1',
      'name': 'Edifício',
      'use_facial_biometric': true,
      'manager_access_control_biometric_status': 'unavailable',
    });
    expect(parsed.name, 'Edifício');
    final entity = parsed.toEntity();
    expect(entity.reference, 'ref-1');
    expect(CondominiumModel.fromEntity(entity)?.id, 'c1');
    expect(Condominium.clone(entity).reference, 'ref-1');
  });

  test('LayoutModel fromJson/toEntity/fromEntity', () {
    final parsed = LayoutModel.fromJson({
      'cod': 'L1',
      'name': 'Tema',
      'reference': 'r',
      'primary': '#000',
      'secondary': '#fff',
      'logo_path': '/logo.png',
    });
    expect(parsed.cod, 'L1');
    expect(parsed.toEntity().name, 'Tema');
    expect(LayoutModel.fromEntity(parsed.toEntity())?.cod, 'L1');
    expect(LayoutModel.fromEntity(null) == null, isTrue);
  });

  test('CondominiumBalanceModel fromJson/toEntity/fromEntity', () {
    final parsed = CondominiumBalanceModel.fromJson({
      'id': 'b1',
      'balance': 10.5,
      'previous_balance': 8,
      'forecast': 1,
      'income': 4,
      'expenses': 2,
      'reference': '2026-01',
    });
    expect(parsed.balance, 10.5);
    expect(parsed.toEntity().income, 4);
    expect(
      CondominiumBalanceModel.fromEntity(
        CondominiumBalance(id: 'b2', balance: 1),
      )?.id,
      'b2',
    );
  });
}
