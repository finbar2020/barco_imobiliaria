// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskResponseModel _$CreateTaskResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreateTaskResponseModel(
      idSchedule: json['idSchedule'] as String,
      idScheduleEvents: (json['idScheduleEvents'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreateTaskResponseModelToJson(
        CreateTaskResponseModel instance) =>
    <String, dynamic>{
      'idSchedule': instance.idSchedule,
      'idScheduleEvents': instance.idScheduleEvents,
    };
