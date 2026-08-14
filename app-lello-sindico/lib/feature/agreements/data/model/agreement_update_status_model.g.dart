// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_update_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementUpdateStatusModel _$AgreementUpdateStatusModelFromJson(
        Map<String, dynamic> json) =>
    AgreementUpdateStatusModel(
      userName: json['user_name'] as String,
      agreementId: json['agreement_id'] as String,
      approved: json['approved'] as bool,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$AgreementUpdateStatusModelToJson(
        AgreementUpdateStatusModel instance) =>
    <String, dynamic>{
      'user_name': instance.userName,
      'agreement_id': instance.agreementId,
      'approved': instance.approved,
      'reason': instance.reason,
    };
