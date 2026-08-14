// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetModel _$TimesheetModelFromJson(Map<String, dynamic> json) =>
    TimesheetModel(
      photo: json['photo'] as String?,
      name: json['name'] as String,
      numCra: json['num_cra'] as String?,
      jobPosition: json['job_position'] as String?,
      signatureId: (json['signature_id'] as num?)?.toInt(),
      occurrences: (json['occurrences'] as num?)?.toInt(),
      signatureEmployee: json['signature_employee'] as bool?,
      signatureManager: json['signature_manager'] as bool?,
      action: $enumDecode(_$TimesheetActionEnumEnumMap, json['action']),
    );

Map<String, dynamic> _$TimesheetModelToJson(TimesheetModel instance) =>
    <String, dynamic>{
      'photo': instance.photo,
      'name': instance.name,
      'num_cra': instance.numCra,
      'job_position': instance.jobPosition,
      'signature_id': instance.signatureId,
      'occurrences': instance.occurrences,
      'signature_employee': instance.signatureEmployee,
      'signature_manager': instance.signatureManager,
      'action': _$TimesheetActionEnumEnumMap[instance.action]!,
    };

const _$TimesheetActionEnumEnumMap = {
  TimesheetActionEnum.sign: 'sign',
  TimesheetActionEnum.notify: 'notify',
  TimesheetActionEnum.none: 'none',
};
