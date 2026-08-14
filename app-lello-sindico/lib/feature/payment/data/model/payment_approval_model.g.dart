// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_approval_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentApprovalModel _$PaymentApprovalModelFromJson(
        Map<String, dynamic> json) =>
    PaymentApprovalModel()
      ..id = json['id'] as String?
      ..paymentId = json['payment_id'] as String?
      ..type = json['type'] as String?
      ..accountId = json['account_id'] as String?
      ..paymentHistory = json['payment_history'] as String?
      ..reason = json['reason'] as String?;

Map<String, dynamic> _$PaymentApprovalModelToJson(
        PaymentApprovalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_id': instance.paymentId,
      'type': instance.type,
      'account_id': instance.accountId,
      'payment_history': instance.paymentHistory,
      'reason': instance.reason,
    };
