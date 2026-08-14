// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_ledger_accounts_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierLedgerAccountsDataModel _$SupplierLedgerAccountsDataModelFromJson(
        Map<String, dynamic> json) =>
    SupplierLedgerAccountsDataModel()
      ..recommendation = json['recommendation'] == null
          ? null
          : SupplierLedgerAccountModel.fromJson(
              json['recommendation'] as Map<String, dynamic>)
      ..ordinary = (json['ordinary'] as List<dynamic>?)
          ?.map((e) =>
              SupplierLedgerAccountModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..extraordinary = (json['extraordinary'] as List<dynamic>?)
          ?.map((e) =>
              SupplierLedgerAccountModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..all = (json['all'] as List<dynamic>?)
          ?.map((e) =>
              SupplierLedgerAccountModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SupplierLedgerAccountsDataModelToJson(
        SupplierLedgerAccountsDataModel instance) =>
    <String, dynamic>{
      'recommendation': instance.recommendation,
      'ordinary': instance.ordinary,
      'extraordinary': instance.extraordinary,
      'all': instance.all,
    };
