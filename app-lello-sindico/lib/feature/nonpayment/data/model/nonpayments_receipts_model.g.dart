// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonpayments_receipts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NonPaymentsReceiptsModel _$NonPaymentsReceiptsModelFromJson(
        Map<String, dynamic> json) =>
    NonPaymentsReceiptsModel()
      ..receipt = json['receipt'] as String?
      ..period = json['period'] == null
          ? null
          : DateTime.parse(json['period'] as String)
      ..valueLiquid = (json['value_liquid'] as num?)?.toDouble()
      ..value = (json['value'] as num?)?.toDouble()
      ..penalty = (json['penalty'] as num?)?.toDouble()
      ..interest = (json['interest'] as num?)?.toDouble();

Map<String, dynamic> _$NonPaymentsReceiptsModelToJson(
        NonPaymentsReceiptsModel instance) =>
    <String, dynamic>{
      'receipt': instance.receipt,
      'period': instance.period?.toIso8601String(),
      'value_liquid': instance.valueLiquid,
      'value': instance.value,
      'penalty': instance.penalty,
      'interest': instance.interest,
    };
