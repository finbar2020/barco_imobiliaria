// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'efficiency_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EfficiencyFiltersModel _$EfficiencyFiltersModelFromJson(
        Map<String, dynamic> json) =>
    EfficiencyFiltersModel(
      typeTask:
          (json['typeTask'] as List<dynamic>).map((e) => e as String).toList(),
      dayCurrent: json['dayCurrent'] as String,
      procedureGroupLabels: (json['procedureGroupLabels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      procedureGroupIds: (json['procedureGroupIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      responsibleIds: (json['responsibleIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      displayBy: json['displayBy'] as String,
      status:
          (json['status'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$EfficiencyFiltersModelToJson(
        EfficiencyFiltersModel instance) =>
    <String, dynamic>{
      'typeTask': instance.typeTask,
      'dayCurrent': instance.dayCurrent,
      'procedureGroupLabels': instance.procedureGroupLabels,
      'procedureGroupIds': instance.procedureGroupIds,
      'responsibleIds': instance.responsibleIds,
      'displayBy': instance.displayBy,
      'status': instance.status,
    };

EfficiencyRequestModel _$EfficiencyRequestModelFromJson(
        Map<String, dynamic> json) =>
    EfficiencyRequestModel(
      dtStart: json['dtStart'] as String,
      untilDate: json['untilDate'] as String,
      filters: EfficiencyFiltersModel.fromJson(
          json['filters'] as Map<String, dynamic>),
      pageName: json['pageName'] as String?,
    );

Map<String, dynamic> _$EfficiencyRequestModelToJson(
        EfficiencyRequestModel instance) =>
    <String, dynamic>{
      'dtStart': instance.dtStart,
      'untilDate': instance.untilDate,
      'filters': instance.filters,
      'pageName': instance.pageName,
    };
