// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_quota_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementQuotaModel _$AgreementQuotaModelFromJson(Map<String, dynamic> json) =>
    AgreementQuotaModel(
      id: json['id'] as String,
      receipt: json['receipt'] as String,
      originValue: (json['origin_value'] as num).toDouble(),
      dueDate: DateTime.parse(json['due_date'] as String),
      fineValue: (json['fine_value'] as num).toDouble(),
      feeValue: (json['fee_value'] as num).toDouble(),
      honoraryValue: (json['honorary_value'] as num).toDouble(),
      overdueMessage: json['overdue_message'] as String,
    );

Map<String, dynamic> _$AgreementQuotaModelToJson(
        AgreementQuotaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receipt': instance.receipt,
      'origin_value': instance.originValue,
      'due_date': instance.dueDate.toIso8601String(),
      'fine_value': instance.fineValue,
      'fee_value': instance.feeValue,
      'honorary_value': instance.honoraryValue,
      'overdue_message': instance.overdueMessage,
    };
