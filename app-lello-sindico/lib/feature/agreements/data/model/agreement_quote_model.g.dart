// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementQuoteModel _$AgreementQuoteModelFromJson(Map<String, dynamic> json) =>
    AgreementQuoteModel(
      id: json['id'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      originValue: (json['origin_value'] as num?)?.toDouble() ?? 0.0,
      fineValue: (json['fine_value'] as num?)?.toDouble() ?? 0.0,
      feeValue: (json['fee_value'] as num?)?.toDouble() ?? 0.0,
      honoraryValue: (json['honorary_value'] as num?)?.toDouble() ?? 0.0,
      overdueMessage: json['overdue_message'] as String?,
    );

Map<String, dynamic> _$AgreementQuoteModelToJson(
        AgreementQuoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'due_date': instance.dueDate?.toIso8601String(),
      'origin_value': instance.originValue,
      'fine_value': instance.fineValue,
      'fee_value': instance.feeValue,
      'honorary_value': instance.honoraryValue,
      'overdue_message': instance.overdueMessage,
    };
