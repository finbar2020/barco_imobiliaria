// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_bank_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinBankAccountModel _$ResinBankAccountModelFromJson(
        Map<String, dynamic> json) =>
    ResinBankAccountModel(
      id: json['id'] as String? ?? "",
      bank: json['bank'] == null
          ? null
          : ResinBankModel.fromJson(json['bank'] as Map<String, dynamic>),
      agency: json['agency'] as String? ?? "",
      accountNumber: json['account_number'] as String? ?? "",
      document: json['document'] as String? ?? "",
      supplierName: json['supplier_name'] as String? ?? "",
      type: json['type'] as String? ?? "",
    );

Map<String, dynamic> _$ResinBankAccountModelToJson(
        ResinBankAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bank': instance.bank,
      'agency': instance.agency,
      'account_number': instance.accountNumber,
      'document': instance.document,
      'supplier_name': instance.supplierName,
      'type': instance.type,
    };
