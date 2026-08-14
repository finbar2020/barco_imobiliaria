// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_referral_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeReferralModel _$EmployeeReferralModelFromJson(
        Map<String, dynamic> json) =>
    EmployeeReferralModel(
      description: json['description'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      hash: json['hash'] as String?,
    );

Map<String, dynamic> _$EmployeeReferralModelToJson(
        EmployeeReferralModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'city': instance.city,
      'region': instance.region,
      'hash': instance.hash,
    };
