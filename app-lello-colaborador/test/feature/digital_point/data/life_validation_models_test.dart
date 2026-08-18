import 'package:colaborador/feature/digital_point/data/model/condominium_life_validation_model.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_life_validation_config_model.dart';
import 'package:colaborador/feature/digital_point/data/model/global_life_validation_config_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_life_validation_config.dart';
import 'package:colaborador/feature/digital_point/domain/entity/global_life_validation_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GlobalLifeValidationConfig.empty', () {
    final empty = GlobalLifeValidationConfig.empty();
    expect(empty.requireLivenessCheck, isFalse);
    expect(empty.qteActionsLifeValidation, 0);
    expect(empty.actionsLifeValidation, isEmpty);
  });

  test('GlobalLifeValidationConfigModel fromJson e toEntity', () {
    final model = GlobalLifeValidationConfigModel.fromJson({
      'require_liveness_check': true,
      'qte_actions_life_validation': 2,
      'is_random_actions_life_validation': false,
      'actions_life_validation': <String>[],
    });
    final entity = model.toEntity();
    expect(entity.requireLivenessCheck, isTrue);
    expect(entity.qteActionsLifeValidation, 2);
    model.toJson();
  });

  test('CondominiumLifeValidationModel fromJson e toEntity', () {
    final model = CondominiumLifeValidationModel.fromJson({
      'referencia': 123,
      'require_liveness_check': true,
      'qte_actions_life_validation': 1,
      'is_random_actions_life_validation': true,
      'actions_life_validation': <String>[],
    });
    expect(model.toEntity().referencia, 123);
    model.toJson();
  });

  test('DigitalPointLifeValidationConfigModel fromJson e toEntity', () {
    final model = DigitalPointLifeValidationConfigModel.fromJson({
      'enabled': true,
      'global_config': {
        'require_liveness_check': false,
        'qte_actions_life_validation': 0,
        'is_random_actions_life_validation': false,
        'actions_life_validation': <String>[],
      },
      'condominiums': [
        {
          'referencia': 1,
          'require_liveness_check': true,
          'actions_life_validation': <String>[],
        }
      ],
    });
    final entity = model.toEntity();
    expect(entity.enabled, isTrue);
    expect(entity.condominiums, hasLength(1));
    expect(DigitalPointLifeValidationConfig.empty().enabled, isFalse);
    model.toJson();
  });
}
