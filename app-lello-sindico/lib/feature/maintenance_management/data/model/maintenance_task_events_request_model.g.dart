// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_task_events_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceTaskEventsRequestFiltersModel
    _$MaintenanceTaskEventsRequestFiltersModelFromJson(
            Map<String, dynamic> json) =>
        MaintenanceTaskEventsRequestFiltersModel(
          typeTask: (json['typeTask'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          procedureGroupLabels: (json['procedureGroupLabels'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          displayBy: json['displayBy'] as String,
          status: (json['status'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          dayCurrent: json['dayCurrent'] as String,
          assetIds: (json['assetIds'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          localIds: (json['localIds'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          responsibleIds: (json['responsibleIds'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$MaintenanceTaskEventsRequestFiltersModelToJson(
        MaintenanceTaskEventsRequestFiltersModel instance) =>
    <String, dynamic>{
      'typeTask': instance.typeTask,
      'procedureGroupLabels': instance.procedureGroupLabels,
      'displayBy': instance.displayBy,
      'status': instance.status,
      'dayCurrent': instance.dayCurrent,
      'assetIds': instance.assetIds,
      'localIds': instance.localIds,
      'responsibleIds': instance.responsibleIds,
    };

MaintenanceTaskEventsRequestModel _$MaintenanceTaskEventsRequestModelFromJson(
        Map<String, dynamic> json) =>
    MaintenanceTaskEventsRequestModel(
      dtstart: json['dtstart'] as String,
      untilDate: json['untilDate'] as String,
      filters: MaintenanceTaskEventsRequestFiltersModel.fromJson(
          json['filters'] as Map<String, dynamic>),
      pageName: json['pageName'] as String?,
    );

Map<String, dynamic> _$MaintenanceTaskEventsRequestModelToJson(
        MaintenanceTaskEventsRequestModel instance) =>
    <String, dynamic>{
      'dtstart': instance.dtstart,
      'untilDate': instance.untilDate,
      'filters': instance.filters,
      'pageName': instance.pageName,
    };
