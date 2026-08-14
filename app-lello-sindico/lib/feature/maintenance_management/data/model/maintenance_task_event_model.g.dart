// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_task_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceTaskEventModel _$MaintenanceTaskEventModelFromJson(
        Map<String, dynamic> json) =>
    MaintenanceTaskEventModel(
      idTask: json['idTask'] as String?,
      idSchedule: json['idSchedule'] as String?,
      idScheduleEvent: json['idScheduleEvent'] as String?,
      typeTask: json['typeTask'] as String,
      name: json['name'] as String,
      fullDescription: json['fullDescription'] as String,
      responsibleUserable: json['responsibleUserable'] as String,
      procedureGroupId: json['procedureGroupId'] as String?,
      responsibleId: json['responsibleId'] as String?,
      timeStart: json['timeStart'] as String,
      timeDescription: json['timeDescription'] as String,
      dtstart: json['dtstart'] as String,
      dtstartFormatted: json['dtstartFormatted'] as String,
      status: json['status'] as String,
      allDay: json['allDay'] as bool,
      rrule: json['rrule'] as String?,
      rruleDescription: json['rruleDescription'] as String?,
      childTasks: (json['childTasks'] as List<dynamic>?)
          ?.map((e) => ChildTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MaintenanceTaskEventModelToJson(
        MaintenanceTaskEventModel instance) =>
    <String, dynamic>{
      'idTask': instance.idTask,
      'idSchedule': instance.idSchedule,
      'idScheduleEvent': instance.idScheduleEvent,
      'typeTask': instance.typeTask,
      'name': instance.name,
      'fullDescription': instance.fullDescription,
      'responsibleUserable': instance.responsibleUserable,
      'procedureGroupId': instance.procedureGroupId,
      'responsibleId': instance.responsibleId,
      'timeStart': instance.timeStart,
      'timeDescription': instance.timeDescription,
      'dtstart': instance.dtstart,
      'dtstartFormatted': instance.dtstartFormatted,
      'status': instance.status,
      'allDay': instance.allDay,
      'rrule': instance.rrule,
      'rruleDescription': instance.rruleDescription,
      'childTasks': instance.childTasks,
    };
