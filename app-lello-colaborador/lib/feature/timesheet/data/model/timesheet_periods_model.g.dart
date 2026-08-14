// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_periods_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetPeriodsModel _$TimesheetPeriodsModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetPeriodsModel(
      periodMonth: DateTime.parse(json['period_month'] as String),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$TimesheetPeriodsModelToJson(
        TimesheetPeriodsModel instance) =>
    <String, dynamic>{
      'period_month': instance.periodMonth.toIso8601String(),
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };
