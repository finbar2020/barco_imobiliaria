// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_month_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskByMonthFiltersModel _$TaskByMonthFiltersModelFromJson(
        Map<String, dynamic> json) =>
    TaskByMonthFiltersModel(
      typeTask:
          (json['typeTask'] as List<dynamic>).map((e) => e as String).toList(),
      status:
          (json['status'] as List<dynamic>).map((e) => e as String).toList(),
      responsibleIds: (json['responsibleIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      localIds:
          (json['localIds'] as List<dynamic>).map((e) => e as String).toList(),
      assetIds:
          (json['assetIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TaskByMonthFiltersModelToJson(
        TaskByMonthFiltersModel instance) =>
    <String, dynamic>{
      'typeTask': instance.typeTask,
      'status': instance.status,
      'responsibleIds': instance.responsibleIds,
      'localIds': instance.localIds,
      'assetIds': instance.assetIds,
    };

TaskByMonthRequestModel _$TaskByMonthRequestModelFromJson(
        Map<String, dynamic> json) =>
    TaskByMonthRequestModel(
      dtStart: json['dtStart'] as String,
      untilDate: json['untilDate'] as String,
      filters: TaskByMonthFiltersModel.fromJson(
          json['filters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskByMonthRequestModelToJson(
        TaskByMonthRequestModel instance) =>
    <String, dynamic>{
      'dtStart': instance.dtStart,
      'untilDate': instance.untilDate,
      'filters': instance.filters,
    };
