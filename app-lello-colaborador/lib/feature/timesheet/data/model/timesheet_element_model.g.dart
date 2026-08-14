// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_element_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetElementModel _$TimesheetElementModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetElementModel(
      date: DateTime.parse(json['date'] as String),
      times: (json['times'] as List<dynamic>).map((e) => e as String).toList(),
      journey: json['journey'] as String,
      hasTreatment: json['has_treatment'] as bool,
      dayOff: json['day_off'] as bool,
    );

Map<String, dynamic> _$TimesheetElementModelToJson(
        TimesheetElementModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'times': instance.times,
      'journey': instance.journey,
      'has_treatment': instance.hasTreatment,
      'day_off': instance.dayOff,
    };
