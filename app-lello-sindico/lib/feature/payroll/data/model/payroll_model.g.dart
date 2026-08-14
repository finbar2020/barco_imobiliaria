// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayrollModel _$PayrollModelFromJson(Map<String, dynamic> json) => PayrollModel()
  ..period =
      json['period'] == null ? null : DateTime.parse(json['period'] as String)
  ..type = json['type'] as String?
  ..value = (json['value'] as num?)?.toDouble()
  ..discounts = (json['discounts'] as num?)?.toDouble()
  ..balance = (json['balance'] as num?)?.toDouble();

Map<String, dynamic> _$PayrollModelToJson(PayrollModel instance) =>
    <String, dynamic>{
      'period': instance.period?.toIso8601String(),
      'type': instance.type,
      'value': instance.value,
      'discounts': instance.discounts,
      'balance': instance.balance,
    };
