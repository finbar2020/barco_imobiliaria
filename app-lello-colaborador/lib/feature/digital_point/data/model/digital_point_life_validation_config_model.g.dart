// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_point_life_validation_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitalPointLifeValidationConfigModel
    _$DigitalPointLifeValidationConfigModelFromJson(
            Map<String, dynamic> json) =>
        DigitalPointLifeValidationConfigModel(
          enabled: json['enabled'] as bool,
          globalConfig: GlobalLifeValidationConfigModel.fromJson(
              json['global_config'] as Map<String, dynamic>),
          condominiums: (json['condominiums'] as List<dynamic>)
              .map((e) => CondominiumLifeValidationModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$DigitalPointLifeValidationConfigModelToJson(
        DigitalPointLifeValidationConfigModel instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'global_config': instance.globalConfig.toJson(),
      'condominiums': instance.condominiums.map((e) => e.toJson()).toList(),
    };
