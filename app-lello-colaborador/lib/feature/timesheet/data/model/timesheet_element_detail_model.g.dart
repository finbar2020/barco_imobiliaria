// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_element_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetElementDetailModel _$TimesheetElementDetailModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetElementDetailModel(
      time: json['time'] as String,
      timesheetFlag: json['timesheet_flag'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$TimesheetElementDetailModelToJson(
        TimesheetElementDetailModel instance) =>
    <String, dynamic>{
      'time': instance.time,
      'timesheet_flag': instance.timesheetFlag,
      'date': instance.date.toIso8601String(),
    };
