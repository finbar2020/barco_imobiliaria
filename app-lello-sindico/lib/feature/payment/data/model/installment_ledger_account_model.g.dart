// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_ledger_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentLedgerAccountModel _$InstallmentLedgerAccountModelFromJson(
        Map<String, dynamic> json) =>
    InstallmentLedgerAccountModel()
      ..shortCode = (json['short_code'] as num?)?.toInt()
      ..name = json['name'] as String?
      ..recommendation = json['recommendation'] as String?
      ..category = json['category'] as String?;

Map<String, dynamic> _$InstallmentLedgerAccountModelToJson(
        InstallmentLedgerAccountModel instance) =>
    <String, dynamic>{
      'short_code': instance.shortCode,
      'name': instance.name,
      'recommendation': instance.recommendation,
      'category': instance.category,
    };
