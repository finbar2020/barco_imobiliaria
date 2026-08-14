// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_local_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskByLocalFiltersModel _$TaskByLocalFiltersModelFromJson(
        Map<String, dynamic> json) =>
    TaskByLocalFiltersModel(
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

Map<String, dynamic> _$TaskByLocalFiltersModelToJson(
        TaskByLocalFiltersModel instance) =>
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

TaskByLocalRequestModel _$TaskByLocalRequestModelFromJson(
        Map<String, dynamic> json) =>
    TaskByLocalRequestModel(
      dtStart: json['dtStart'] as String,
      untilDate: json['untilDate'] as String,
      filters: json['filters'] == null
          ? null
          : TaskByLocalFiltersModel.fromJson(
              json['filters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskByLocalRequestModelToJson(
        TaskByLocalRequestModel instance) =>
    <String, dynamic>{
      'dtStart': instance.dtStart,
      'untilDate': instance.untilDate,
      'filters': instance.filters,
    };
