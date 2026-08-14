// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_approver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentApproverModel _$InstallmentApproverModelFromJson(
        Map<String, dynamic> json) =>
    InstallmentApproverModel()
      ..name = json['name'] as String?
      ..status = json['status'] as String?
      ..approvalDate = json['approval_date'] as String?
      ..approvalTime = json['approval_time'] as String?
      ..channel = json['channel'] as String?;

Map<String, dynamic> _$InstallmentApproverModelToJson(
        InstallmentApproverModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'status': instance.status,
      'approval_date': instance.approvalDate,
      'approval_time': instance.approvalTime,
      'channel': instance.channel,
    };
