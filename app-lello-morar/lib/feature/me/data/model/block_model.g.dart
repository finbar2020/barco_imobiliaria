// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockModel _$BlockModelFromJson(Map<String, dynamic> json) => BlockModel()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..units = (json['units'] as List<dynamic>?)
      ?.map((e) => UnityModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$BlockModelToJson(BlockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'units': instance.units,
    };
