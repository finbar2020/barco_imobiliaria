// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_simple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockSimpleModel _$BlockSimpleModelFromJson(Map<String, dynamic> json) =>
    BlockSimpleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      units: (json['units'] as List<dynamic>)
          .map((e) => UnitSimpleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockSimpleModelToJson(BlockSimpleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'units': instance.units,
    };
