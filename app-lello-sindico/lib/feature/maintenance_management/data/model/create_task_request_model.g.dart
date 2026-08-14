// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RruleModel _$RruleModelFromJson(Map<String, dynamic> json) => RruleModel(
      frequency: json['frequency'] as String,
      byDays:
          (json['byDays'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RruleModelToJson(RruleModel instance) =>
    <String, dynamic>{
      'frequency': instance.frequency,
      'byDays': instance.byDays,
    };

CreateTaskRequestModel _$CreateTaskRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateTaskRequestModel(
      procedureGroupId: json['procedureGroupId'] as String,
      procedureId: json['procedureId'] as String,
      localId: json['localId'] as String?,
      assetId: json['assetId'] as String?,
      allDay: json['allDay'] as bool,
      dtStart: json['dtStart'] as String,
      timeStart: json['timeStart'] as String?,
      repeat: json['repeat'] as bool,
      rrule: json['rrule'] == null
          ? null
          : RruleModel.fromJson(json['rrule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateTaskRequestModelToJson(
        CreateTaskRequestModel instance) =>
    <String, dynamic>{
      'procedureGroupId': instance.procedureGroupId,
      'procedureId': instance.procedureId,
      if (instance.localId case final value?) 'localId': value,
      'assetId': instance.assetId,
      'allDay': instance.allDay,
      'dtStart': instance.dtStart,
      'timeStart': instance.timeStart,
      'repeat': instance.repeat,
      'rrule': instance.rrule,
    };
