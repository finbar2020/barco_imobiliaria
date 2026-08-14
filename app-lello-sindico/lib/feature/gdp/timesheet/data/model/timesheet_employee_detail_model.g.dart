// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_employee_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetEmployeeDetailModel _$TimesheetEmployeeDetailModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetEmployeeDetailModel(
      startDateOfAssessment:
          DateTime.parse(json['start_date_of_assessment'] as String),
      endDateOfAssessment:
          DateTime.parse(json['end_date_of_assessment'] as String),
      signatureId: json['signature_id'],
      employeeSigned: json['employee_signed'] as bool,
      syndicateSigned: json['syndicate_signed'] as bool,
      action: $enumDecode(_$TimesheetActionEnumEnumMap, json['action']),
      markings: (json['markings'] as List<dynamic>)
          .map((e) =>
              TimesheetEmployeeMarksModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimesheetEmployeeDetailModelToJson(
        TimesheetEmployeeDetailModel instance) =>
    <String, dynamic>{
      'start_date_of_assessment':
          instance.startDateOfAssessment.toIso8601String(),
      'end_date_of_assessment': instance.endDateOfAssessment.toIso8601String(),
      'signature_id': instance.signatureId,
      'employee_signed': instance.employeeSigned,
      'syndicate_signed': instance.syndicateSigned,
      'action': _$TimesheetActionEnumEnumMap[instance.action]!,
      'markings': instance.markings,
    };

const _$TimesheetActionEnumEnumMap = {
  TimesheetActionEnum.sign: 'sign',
  TimesheetActionEnum.notify: 'notify',
  TimesheetActionEnum.none: 'none',
};
