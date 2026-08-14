// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_installment_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInstallmentRequestBody _$UpdateInstallmentRequestBodyFromJson(
        Map<String, dynamic> json) =>
    UpdateInstallmentRequestBody(
      status: json['status'] as String,
      reason: json['reason'] as String,
      channel: json['channel'] as String,
      installments: (json['installments'] as List<dynamic>)
          .map((e) =>
              UpdateTransactionInstallments.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UpdateInstallmentRequestBodyToJson(
        UpdateInstallmentRequestBody instance) =>
    <String, dynamic>{
      'status': instance.status,
      'reason': instance.reason,
      'channel': instance.channel,
      'installments': instance.installments,
    };
