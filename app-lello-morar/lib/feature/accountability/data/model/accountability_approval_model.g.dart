// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountability_approval_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityApprovalModel _$AccountabilityApprovalModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityApprovalModel()
      ..id = json['id'] as String?
      ..accountability = json['accountability'] == null
          ? null
          : AccountabilityModel.fromJson(
              json['accountability'] as Map<String, dynamic>)
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String);

Map<String, dynamic> _$AccountabilityApprovalModelToJson(
        AccountabilityApprovalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountability': instance.accountability,
      'date': instance.date?.toIso8601String(),
    };
