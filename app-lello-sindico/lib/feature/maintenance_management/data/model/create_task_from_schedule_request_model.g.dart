// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_from_schedule_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskFromScheduleRequestModel _$CreateTaskFromScheduleRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateTaskFromScheduleRequestModel(
      scheduleId: json['scheduleId'] as String,
      scheduleEventId: json['scheduleEventId'] as String,
    );

Map<String, dynamic> _$CreateTaskFromScheduleRequestModelToJson(
        CreateTaskFromScheduleRequestModel instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'scheduleEventId': instance.scheduleEventId,
    };
