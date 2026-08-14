// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarDayModel _$CalendarDayModelFromJson(Map<String, dynamic> json) =>
    CalendarDayModel(
      day: (json['day'] as num).toInt(),
      hasEvents: json['hasEvents'] as bool,
      taskCount: (json['taskCount'] as num).toInt(),
    );

Map<String, dynamic> _$CalendarDayModelToJson(CalendarDayModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hasEvents': instance.hasEvents,
      'taskCount': instance.taskCount,
    };
