import 'dart:convert';

import 'package:colaborador/feature/authentication_tablet/data/model/condo_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/employee_info_model.dart';
import 'package:flutter_test/flutter_test.dart';

CondominiumCodeInfoModel _validModel(String code) => CondominiumCodeInfoModel(
      condoCode: code,
      condominium: CondoInfoModel(
        reference: 'R1',
        name: 'Torre Lello',
        picturehash: 'pic',
        status: 'active',
        ref: 'ref1',
      ),
      employees: [
        EmployeeInfoModel(
          numCra: '1',
          numCad: '2',
          cpf: '123',
          name: 'Ana Silva',
          jobPosition: 'porteiro',
        ),
      ],
    );

void main() {
  group('CondominiumCodeInfoModel', () {
    test('isValid exige condomínio', () {
      expect(CondominiumCodeInfoModel().isValid, isFalse);
      expect(_validModel('123').isValid, isTrue);
    });

    test('toEntity retorna null quando inválido', () {
      expect(CondominiumCodeInfoModel().toEntity(), isNull);
    });

    test('toEntity mapeia condomínio e funcionários', () {
      final entity = _validModel('123').toEntity();
      expect(entity?.condoCode, '123');
      expect(entity?.condominium.name, 'Torre Lello');
      expect(entity?.employees, hasLength(1));
      expect(entity?.employees.first.name, 'Ana Silva');
    });

    test('fromJson e toJson preservam dados', () {
      final model = _validModel('456');
      final restored = CondominiumCodeInfoModel.fromJson(
        jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>,
      );
      expect(restored.condoCode, '456');
      expect(restored.condominium?.name, 'Torre Lello');
      expect(restored.employees, hasLength(1));
    });

    test('fromEntity e toEntity são reversíveis', () {
      final entity = _validModel('789').toEntity()!;
      final roundTrip = CondominiumCodeInfoModel.fromEntity(entity)?.toEntity();
      expect(roundTrip?.condoCode, '789');
      expect(roundTrip?.employees.first.cpf, '123');
    });
  });

  group('CondoInfoModel', () {
    test('fromEntity e toEntity', () {
      final model = CondoInfoModel(reference: 'R2', name: 'Condo');
      final entity = model.toEntity();
      expect(CondoInfoModel.fromEntity(entity)?.reference, 'R2');
    });
  });

  group('EmployeeInfoModel', () {
    test('fromEntity e toEntity', () {
      final model = EmployeeInfoModel(name: 'João', cpf: '111');
      final entity = model.toEntity();
      expect(EmployeeInfoModel.fromEntity(entity)?.name, 'João');
      expect(entity.cpf, '111');
    });
  });
}
