// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountability_period_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityPeriodModel _$AccountabilityPeriodModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityPeriodModel()
      ..period = json['period'] == null
          ? null
          : DateTime.parse(json['period'] as String)
      ..situation = json['situation'] as String?
      ..approvalDate = json['approval_date'] == null
          ? null
          : DateTime.parse(json['approval_date'] as String);

Map<String, dynamic> _$AccountabilityPeriodModelToJson(
        AccountabilityPeriodModel instance) =>
    <String, dynamic>{
      'period': instance.period?.toIso8601String(),
      'situation': instance.situation,
      'approval_date': instance.approvalDate?.toIso8601String(),
    };
