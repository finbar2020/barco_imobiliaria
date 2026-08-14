// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_task_events_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceTaskEventsResponseModel _$MaintenanceTaskEventsResponseModelFromJson(
        Map<String, dynamic> json) =>
    MaintenanceTaskEventsResponseModel(
      taskSummaryDay: TaskSummaryModel.fromJson(
          json['taskSummaryDay'] as Map<String, dynamic>),
      taskFormulary: (json['taskFormulary'] as List<dynamic>)
          .map((e) =>
              MaintenanceTaskEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MaintenanceTaskEventsResponseModelToJson(
        MaintenanceTaskEventsResponseModel instance) =>
    <String, dynamic>{
      'taskSummaryDay': instance.taskSummaryDay,
      'taskFormulary': instance.taskFormulary,
    };
