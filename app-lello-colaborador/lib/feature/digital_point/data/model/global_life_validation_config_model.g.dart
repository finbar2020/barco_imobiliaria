// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_life_validation_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalLifeValidationConfigModel _$GlobalLifeValidationConfigModelFromJson(
        Map<String, dynamic> json) =>
    GlobalLifeValidationConfigModel(
      requireLivenessCheck: json['require_liveness_check'] as bool,
      qteActionsLifeValidation:
          (json['qte_actions_life_validation'] as num).toInt(),
      isRandomActionsLifeValidation:
          json['is_random_actions_life_validation'] as bool,
      actionsLifeValidation: (json['actions_life_validation'] as List<dynamic>)
          .map((e) => $enumDecode(_$LifeValidationTypeEnumEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$GlobalLifeValidationConfigModelToJson(
        GlobalLifeValidationConfigModel instance) =>
    <String, dynamic>{
      'require_liveness_check': instance.requireLivenessCheck,
      'qte_actions_life_validation': instance.qteActionsLifeValidation,
      'is_random_actions_life_validation':
          instance.isRandomActionsLifeValidation,
      'actions_life_validation': instance.actionsLifeValidation
          .map((e) => _$LifeValidationTypeEnumEnumMap[e]!)
          .toList(),
    };

const _$LifeValidationTypeEnumEnumMap = {
  LifeValidationTypeEnum.right: 'right',
  LifeValidationTypeEnum.left: 'left',
  LifeValidationTypeEnum.down: 'down',
  LifeValidationTypeEnum.up: 'up',
  LifeValidationTypeEnum.smile: 'smile',
  LifeValidationTypeEnum.blink: 'blink',
};
