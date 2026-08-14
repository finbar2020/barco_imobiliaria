// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_asset_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskByAssetDataModel _$TaskByAssetDataModelFromJson(
        Map<String, dynamic> json) =>
    TaskByAssetDataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      done: (json['done'] as num?)?.toInt(),
      draft: (json['draft'] as num?)?.toInt(),
      notStarted: (json['not_started'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskByAssetDataModelToJson(
        TaskByAssetDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'done': instance.done,
      'draft': instance.draft,
      'not_started': instance.notStarted,
      'total': instance.total,
    };
