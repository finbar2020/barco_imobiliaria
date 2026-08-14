// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_occurrence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetOccurrenceModel _$TimesheetOccurrenceModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetOccurrenceModel(
      photo: json['photo'] as String?,
      name: json['name'] as String?,
      jobPosition: json['job_position'] as String?,
      numCra: json['num_cra'] as String?,
      receivedMark: json['received_mark'] as String?,
      hourRange: json['hour_range'] as String?,
      referenceDate: json['reference_date'] as String?,
      occurrenceName: json['occurrence_name'] as String?,
      occurrenceType: json['occurrence_type'] as String?,
      occurenceDuration: (json['occurence_duration'] as num).toInt(),
      canTreat: json['can_treat'] as bool,
    );

Map<String, dynamic> _$TimesheetOccurrenceModelToJson(
        TimesheetOccurrenceModel instance) =>
    <String, dynamic>{
      'photo': instance.photo,
      'name': instance.name,
      'job_position': instance.jobPosition,
      'num_cra': instance.numCra,
      'received_mark': instance.receivedMark,
      'hour_range': instance.hourRange,
      'reference_date': instance.referenceDate,
      'occurence_duration': instance.occurenceDuration,
      'occurrence_name': instance.occurrenceName,
      'can_treat': instance.canTreat,
      'occurrence_type': instance.occurrenceType,
    };
