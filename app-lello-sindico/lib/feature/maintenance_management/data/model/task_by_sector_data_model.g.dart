// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_sector_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskBySectorDataModel _$TaskBySectorDataModelFromJson(
        Map<String, dynamic> json) =>
    TaskBySectorDataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      value: (json['value'] as num).toInt(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$TaskBySectorDataModelToJson(
        TaskBySectorDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'color': instance.color,
    };
