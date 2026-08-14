// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetModel _$TimesheetModelFromJson(Map<String, dynamic> json) =>
    TimesheetModel(
      dateFrom: DateTime.parse(json['date_from'] as String),
      dateTo: DateTime.parse(json['date_to'] as String),
      dateLiberation: json['date_liberation'] == null
          ? null
          : DateTime.parse(json['date_liberation'] as String),
      timesheetStatus: json['timesheet_status'] as String,
      timesheetElements: (json['timesheet_elements'] as List<dynamic>)
          .map((e) => TimesheetElementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimesheetModelToJson(TimesheetModel instance) =>
    <String, dynamic>{
      'date_from': instance.dateFrom.toIso8601String(),
      'date_to': instance.dateTo.toIso8601String(),
      'date_liberation': instance.dateLiberation?.toIso8601String(),
      'timesheet_status': instance.timesheetStatus,
      'timesheet_elements': instance.timesheetElements,
    };
