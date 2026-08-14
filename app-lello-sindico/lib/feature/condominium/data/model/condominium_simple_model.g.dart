// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_simple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumSimpleModel _$CondominiumSimpleModelFromJson(
        Map<String, dynamic> json) =>
    CondominiumSimpleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      reference: json['reference'] as String,
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => BlockSimpleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CondominiumSimpleModelToJson(
        CondominiumSimpleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reference': instance.reference,
      'blocks': instance.blocks,
    };
