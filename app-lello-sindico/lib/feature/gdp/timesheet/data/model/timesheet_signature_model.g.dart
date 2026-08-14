// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_signature_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetSignatureModel _$TimesheetSignatureModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetSignatureModel(
      id: (json['id'] as num?)?.toInt(),
      approvedFlag: json['approved_flag'] as bool?,
      numCra: json['num_cra'] as String?,
      notify: json['notify'] as bool?,
    );

Map<String, dynamic> _$TimesheetSignatureModelToJson(
        TimesheetSignatureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'approved_flag': instance.approvedFlag,
      'num_cra': instance.numCra,
      'notify': instance.notify,
    };
