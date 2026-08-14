// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetFilterModel _$TimesheetFilterModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetFilterModel()
      ..name = json['name'] as String?
      ..id = json['id'] as String?
      ..type = json['type'] as String?
      ..dobFrom = json['dob_from'] == null
          ? null
          : DateTime.parse(json['dob_from'] as String)
      ..dobTo = json['dob_to'] == null
          ? null
          : DateTime.parse(json['dob_to'] as String);

Map<String, dynamic> _$TimesheetFilterModelToJson(
        TimesheetFilterModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'type': instance.type,
      'dob_from': instance.dobFrom?.toIso8601String(),
      'dob_to': instance.dobTo?.toIso8601String(),
    };
