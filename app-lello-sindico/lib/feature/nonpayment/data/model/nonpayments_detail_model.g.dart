// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonpayments_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NonPaymentsDetailModel _$NonPaymentsDetailModelFromJson(
        Map<String, dynamic> json) =>
    NonPaymentsDetailModel(
      period: json['period'] == null
          ? null
          : DateTime.parse(json['period'] as String),
      valueLiquid: (json['value_liquid'] as num?)?.toDouble(),
      interest: (json['interest'] as num?)?.toDouble(),
      penalty: (json['penalty'] as num?)?.toDouble(),
      value: (json['value'] as num?)?.toDouble(),
      resident: json['resident'] == null
          ? null
          : ResidentModel.fromJson(json['resident'] as Map<String, dynamic>),
      receipts: (json['receipts'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : NonPaymentsReceiptsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NonPaymentsDetailModelToJson(
        NonPaymentsDetailModel instance) =>
    <String, dynamic>{
      'period': instance.period?.toIso8601String(),
      'value_liquid': instance.valueLiquid,
      'interest': instance.interest,
      'penalty': instance.penalty,
      'value': instance.value,
      'resident': instance.resident,
      'receipts': instance.receipts,
    };
