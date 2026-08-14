// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumModel _$CondominiumModelFromJson(Map<String, dynamic> json) =>
    CondominiumModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..address = json['address'] as String?
      ..reference = json['reference'] as String?
      ..blocks = (json['blocks'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : BlockModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..regulationUrl = json['regulation_url'] as String?
      ..active_manager = json['active_manager'] as bool?
      ..useFacialBiometric = json['use_facial_biometric'] as bool?
      ..layout = json['layout'] == null
          ? null
          : LayoutModel.fromJson(json['layout'] as Map<String, dynamic>);

Map<String, dynamic> _$CondominiumModelToJson(CondominiumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'reference': instance.reference,
      'blocks': instance.blocks,
      'regulation_url': instance.regulationUrl,
      'active_manager': instance.active_manager,
      'use_facial_biometric': instance.useFacialBiometric,
      'layout': instance.layout,
    };
