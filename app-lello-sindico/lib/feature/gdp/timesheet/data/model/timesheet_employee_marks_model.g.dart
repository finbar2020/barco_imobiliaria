// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_employee_marks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetEmployeeMarksModel _$TimesheetEmployeeMarksModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetEmployeeMarksModel(
      craNumber: json['cra_number'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      referenceDate: json['reference_date'] == null
          ? null
          : DateTime.parse(json['reference_date'] as String),
      type: json['type'] as String,
      receivedMarking: json['received_marking'] as String? ?? '',
      occurrenceDuration: (json['occurrence_duration'] as num?)?.toInt() ?? 0,
      outOfRadius: json['out_of_radius'] as bool? ?? false,
    );

Map<String, dynamic> _$TimesheetEmployeeMarksModelToJson(
        TimesheetEmployeeMarksModel instance) =>
    <String, dynamic>{
      'cra_number': instance.craNumber,
      'reference': instance.reference,
      'reference_date': instance.referenceDate?.toIso8601String(),
      'type': instance.type,
      'received_marking': instance.receivedMarking,
      'occurrence_duration': instance.occurrenceDuration,
      'out_of_radius': instance.outOfRadius,
    };
