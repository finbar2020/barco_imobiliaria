// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_life_validation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumLifeValidationModel _$CondominiumLifeValidationModelFromJson(
        Map<String, dynamic> json) =>
    CondominiumLifeValidationModel(
      referencia: (json['referencia'] as num).toInt(),
      requireLivenessCheck: json['require_liveness_check'] as bool,
      qteActionsLifeValidation:
          (json['qte_actions_life_validation'] as num?)?.toInt(),
      isRandomActionsLifeValidation:
          json['is_random_actions_life_validation'] as bool?,
      actionsLifeValidation: (json['actions_life_validation'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LifeValidationTypeEnumEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$CondominiumLifeValidationModelToJson(
        CondominiumLifeValidationModel instance) =>
    <String, dynamic>{
      'referencia': instance.referencia,
      'require_liveness_check': instance.requireLivenessCheck,
      'qte_actions_life_validation': instance.qteActionsLifeValidation,
      'is_random_actions_life_validation':
          instance.isRandomActionsLifeValidation,
      'actions_life_validation': instance.actionsLifeValidation
          ?.map((e) => _$LifeValidationTypeEnumEnumMap[e]!)
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
