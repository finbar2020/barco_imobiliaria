// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_occurrence_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetOccurrenceRequestModel _$TimesheetOccurrenceRequestModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetOccurrenceRequestModel(
      numCra: json['num_cra'] as String? ?? "",
      typeOccurrence: json['type_occurrence'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );

Map<String, dynamic> _$TimesheetOccurrenceRequestModelToJson(
        TimesheetOccurrenceRequestModel instance) =>
    <String, dynamic>{
      'num_cra': instance.numCra,
      'type_occurrence': instance.typeOccurrence,
      'date': instance.date,
    };
