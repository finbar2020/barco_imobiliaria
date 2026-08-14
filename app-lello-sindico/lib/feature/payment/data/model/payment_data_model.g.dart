// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDataModel _$PaymentDataModelFromJson(Map<String, dynamic> json) =>
    PaymentDataModel(
      idSupplier: (json['id_supplier'] as num?)?.toInt(),
      documentSupplier: json['document_supplier'] as String?,
      idContract: (json['id_contract'] as num?)?.toInt(),
      documentNumber: json['document_number'] as String?,
      documentType: json['document_type'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      installmentQuantity: (json['installment_quantity'] as num?)?.toInt(),
      totalValue: (json['total_value'] as num?)?.toDouble(),
      observation: json['observation'] as String?,
      filePathLaunch: json['file_path_launch'] as String?,
      totalPages: (json['total_pages'] as num?)?.toInt(),
      ledgerAccount: (json['ledger_account'] as num?)?.toInt(),
      isUtilityAccount: json['is_utility_account'] as bool?,
      isSendFinancial: json['is_send_financial'] as bool? ?? false,
      installments: (json['installments'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : InstallmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PaymentDataModelToJson(PaymentDataModel instance) =>
    <String, dynamic>{
      'id_supplier': instance.idSupplier,
      'document_supplier': instance.documentSupplier,
      'id_contract': instance.idContract,
      'document_number': instance.documentNumber,
      'document_type': instance.documentType,
      'due_date': instance.dueDate?.toIso8601String(),
      'installment_quantity': instance.installmentQuantity,
      'total_value': instance.totalValue,
      'observation': instance.observation,
      'file_path_launch': instance.filePathLaunch,
      'total_pages': instance.totalPages,
      'ledger_account': instance.ledgerAccount,
      'is_utility_account': instance.isUtilityAccount,
      'is_send_financial': instance.isSendFinancial,
      'installments': instance.installments,
    };
