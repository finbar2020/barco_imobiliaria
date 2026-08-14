// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_add_manual_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetAddManualModel _$TimesheetAddManualModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetAddManualModel(
      numCra: json['num_cra'] as String,
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$TimesheetAddManualEnumEnumMap, json['type']),
      justification: json['justification'] as String,
      marks: (json['marks'] as List<dynamic>).map((e) => e as String).toList(),
      single: json['single'] as bool,
    );

Map<String, dynamic> _$TimesheetAddManualModelToJson(
        TimesheetAddManualModel instance) =>
    <String, dynamic>{
      'num_cra': instance.numCra,
      'date': instance.date.toIso8601String(),
      'type': _$TimesheetAddManualEnumEnumMap[instance.type]!,
      'justification': instance.justification,
      'marks': instance.marks,
      'single': instance.single,
    };

const _$TimesheetAddManualEnumEnumMap = {
  TimesheetAddManualEnum.casual_schedule: 'casual_schedule',
  TimesheetAddManualEnum.lunch_schedule: 'lunch_schedule',
  TimesheetAddManualEnum.standard_schedule: 'standard_schedule',
};
