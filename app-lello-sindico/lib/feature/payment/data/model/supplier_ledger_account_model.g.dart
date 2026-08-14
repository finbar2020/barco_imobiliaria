// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_ledger_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierLedgerAccountModel _$SupplierLedgerAccountModelFromJson(
        Map<String, dynamic> json) =>
    SupplierLedgerAccountModel()
      ..id = (json['id'] as num?)?.toInt()
      ..name = json['name'] as String?;

Map<String, dynamic> _$SupplierLedgerAccountModelToJson(
        SupplierLedgerAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
