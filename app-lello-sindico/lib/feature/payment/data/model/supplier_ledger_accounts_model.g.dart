// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_ledger_accounts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierLedgerAccountsModel _$SupplierLedgerAccountsModelFromJson(
        Map<String, dynamic> json) =>
    SupplierLedgerAccountsModel(
      recommendation: json['recommendation'] == null
          ? null
          : LedgerAccountModel.fromJson(
              json['recommendation'] as Map<String, dynamic>),
      ordinary: (json['ordinary'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : LedgerAccountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      extraordinary: (json['extraordinary'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : LedgerAccountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      all: (json['all'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : LedgerAccountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SupplierLedgerAccountsModelToJson(
        SupplierLedgerAccountsModel instance) =>
    <String, dynamic>{
      'recommendation': instance.recommendation,
      'ordinary': instance.ordinary,
      'extraordinary': instance.extraordinary,
      'all': instance.all,
    };
