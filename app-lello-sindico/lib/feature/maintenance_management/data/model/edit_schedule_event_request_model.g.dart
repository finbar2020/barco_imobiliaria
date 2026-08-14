// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_schedule_event_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditScheduleEventRequestModel _$EditScheduleEventRequestModelFromJson(
        Map<String, dynamic> json) =>
    EditScheduleEventRequestModel(
      idSchedule: json['idSchedule'] as String,
      idScheduleEvent: json['idScheduleEvent'] as String,
      dtStart: json['dtStart'] as String,
      timeStart: json['timeStart'] as String?,
      timeEnd: json['timeEnd'] as String?,
      allDay: json['allDay'] as bool,
      repeat: json['repeat'] as bool,
      until: json['until'] as String?,
      procedureGroupId: json['procedureGroupId'] as String?,
      procedureId: json['procedureId'] as String?,
      localId: json['localId'] as String?,
      assetId: json['assetId'] as String?,
      updateType: json['updateType'] as String,
      rrule: json['rrule'] == null
          ? null
          : EditScheduleEventRRuleModel.fromJson(
              json['rrule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditScheduleEventRequestModelToJson(
        EditScheduleEventRequestModel instance) =>
    <String, dynamic>{
      'idSchedule': instance.idSchedule,
      'idScheduleEvent': instance.idScheduleEvent,
      'dtStart': instance.dtStart,
      'timeStart': instance.timeStart,
      'timeEnd': instance.timeEnd,
      'allDay': instance.allDay,
      'repeat': instance.repeat,
      'until': instance.until,
      'procedureGroupId': instance.procedureGroupId,
      'procedureId': instance.procedureId,
      'localId': instance.localId,
      'assetId': instance.assetId,
      'updateType': instance.updateType,
      'rrule': instance.rrule,
    };

EditScheduleEventRRuleModel _$EditScheduleEventRRuleModelFromJson(
        Map<String, dynamic> json) =>
    EditScheduleEventRRuleModel(
      frequency: json['frequency'] as String,
      byDays:
          (json['byDays'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$EditScheduleEventRRuleModelToJson(
        EditScheduleEventRRuleModel instance) =>
    <String, dynamic>{
      'frequency': instance.frequency,
      'byDays': instance.byDays,
    };
