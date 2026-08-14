// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetEventModel _$TimesheetEventModelFromJson(Map<String, dynamic> json) =>
    TimesheetEventModel()
      ..id = json['id'] as String?
      ..registrationNumber = json['registration_number'] as String?
      ..reference = json['reference'] as String?
      ..minutes = (json['minutes'] as num?)?.toInt()
      ..createdBy = json['created_by'] as String?
      ..flagProcessed = json['flag_processed'] as bool?
      ..typeEvent = json['type_event'] as String?
      ..effectiveDate = json['effective_date'] == null
          ? null
          : DateTime.parse(json['effective_date'] as String)
      ..processDate = json['process_date'] == null
          ? null
          : DateTime.parse(json['process_date'] as String)
      ..createdDate = json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String)
      ..changedDate = json['changed_date'] == null
          ? null
          : DateTime.parse(json['changed_date'] as String);

Map<String, dynamic> _$TimesheetEventModelToJson(
        TimesheetEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'registration_number': instance.registrationNumber,
      'reference': instance.reference,
      'minutes': instance.minutes,
      'created_by': instance.createdBy,
      'flag_processed': instance.flagProcessed,
      'type_event': instance.typeEvent,
      'effective_date': instance.effectiveDate?.toIso8601String(),
      'process_date': instance.processDate?.toIso8601String(),
      'created_date': instance.createdDate?.toIso8601String(),
      'changed_date': instance.changedDate?.toIso8601String(),
    };
