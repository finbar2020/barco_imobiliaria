// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierDataModel _$SupplierDataModelFromJson(Map<String, dynamic> json) =>
    SupplierDataModel(
      id: (json['id'] as num?)?.toInt(),
      document: json['document'] as String?,
      name: json['name'] as String?,
      contracts: (json['contracts'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : ContractModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      supplierPaymentTypes: (json['supplier_payment_types'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : SupplierPaymentTypeModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      supplierLedgerAccounts: json['supplier_ledger_accounts'] == null
          ? null
          : SupplierLedgerAccountsModel.fromJson(
              json['supplier_ledger_accounts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupplierDataModelToJson(SupplierDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'document': instance.document,
      'name': instance.name,
      'contracts': instance.contracts,
      'supplier_payment_types': instance.supplierPaymentTypes,
      'supplier_ledger_accounts': instance.supplierLedgerAccounts,
    };
