// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formulary_by_month_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormularyByMonthFiltersModel _$FormularyByMonthFiltersModelFromJson(
        Map<String, dynamic> json) =>
    FormularyByMonthFiltersModel(
      typeTask:
          (json['typeTask'] as List<dynamic>).map((e) => e as String).toList(),
      status:
          (json['status'] as List<dynamic>).map((e) => e as String).toList(),
      dayCurrent: json['dayCurrent'] as String,
      responsibleIds: (json['responsibleIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      localIds:
          (json['localIds'] as List<dynamic>).map((e) => e as String).toList(),
      assetIds:
          (json['assetIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FormularyByMonthFiltersModelToJson(
        FormularyByMonthFiltersModel instance) =>
    <String, dynamic>{
      'typeTask': instance.typeTask,
      'status': instance.status,
      'dayCurrent': instance.dayCurrent,
      'responsibleIds': instance.responsibleIds,
      'localIds': instance.localIds,
      'assetIds': instance.assetIds,
    };

FormularyByMonthRequestModel _$FormularyByMonthRequestModelFromJson(
        Map<String, dynamic> json) =>
    FormularyByMonthRequestModel(
      dtStart: json['dtStart'] as String,
      untilDate: json['untilDate'] as String,
      filters: FormularyByMonthFiltersModel.fromJson(
          json['filters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FormularyByMonthRequestModelToJson(
        FormularyByMonthRequestModel instance) =>
    <String, dynamic>{
      'dtStart': instance.dtStart,
      'untilDate': instance.untilDate,
      'filters': instance.filters,
    };
