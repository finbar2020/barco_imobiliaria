// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_sector_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskBySectorFiltersModel _$TaskBySectorFiltersModelFromJson(
        Map<String, dynamic> json) =>
    TaskBySectorFiltersModel(
      responsibleIds: (json['responsibleIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      assetIds: (json['assetIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      localIds: (json['localIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      typeTask: (json['typeTask'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status:
          (json['status'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dayCurrent: json['dayCurrent'] as String?,
      localGroupIds: (json['localGroupIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      procedureIds: (json['procedureIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      assetGroupIds: (json['assetGroupIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sectorIds: (json['sectorIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TaskBySectorFiltersModelToJson(
        TaskBySectorFiltersModel instance) =>
    <String, dynamic>{
      'responsibleIds': instance.responsibleIds,
      'assetIds': instance.assetIds,
      'localIds': instance.localIds,
      'typeTask': instance.typeTask,
      'status': instance.status,
      'dayCurrent': instance.dayCurrent,
      'localGroupIds': instance.localGroupIds,
      'procedureIds': instance.procedureIds,
      'assetGroupIds': instance.assetGroupIds,
      'sectorIds': instance.sectorIds,
    };

TaskBySectorRequestModel _$TaskBySectorRequestModelFromJson(
        Map<String, dynamic> json) =>
    TaskBySectorRequestModel(
      dtStart: json['dtStart'] as String,
      untilDate: json['untilDate'] as String,
      filters: json['filters'] == null
          ? null
          : TaskBySectorFiltersModel.fromJson(
              json['filters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskBySectorRequestModelToJson(
        TaskBySectorRequestModel instance) =>
    <String, dynamic>{
      'dtStart': instance.dtStart,
      'untilDate': instance.untilDate,
      'filters': instance.filters,
    };
