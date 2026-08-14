// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_signature_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetSignatureModel _$TimesheetSignatureModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetSignatureModel()
      ..id = (json['id'] as num?)?.toInt()
      ..employee = json['employee'] == null
          ? null
          : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>)
      ..signatureDateTime = json['signature_date_time'] == null
          ? null
          : DateTime.parse(json['signature_date_time'] as String)
      ..periodDate = json['period_date'] == null
          ? null
          : DateTime.parse(json['period_date'] as String)
      ..approvedFlag = json['approved_flag'] as bool?
      ..typeSignature = json['type_signature'] as String?;

Map<String, dynamic> _$TimesheetSignatureModelToJson(
        TimesheetSignatureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee': instance.employee,
      'signature_date_time': instance.signatureDateTime?.toIso8601String(),
      'period_date': instance.periodDate?.toIso8601String(),
      'approved_flag': instance.approvedFlag,
      'type_signature': instance.typeSignature,
    };
