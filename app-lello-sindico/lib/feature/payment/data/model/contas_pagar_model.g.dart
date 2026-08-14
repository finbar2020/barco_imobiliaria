// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contas_pagar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContasPagarModel _$ContasPagarModelFromJson(Map<String, dynamic> json) =>
    ContasPagarModel()
      ..installmentId = (json['installment_id'] as num?)?.toInt()
      ..supplierId = (json['supplier_id'] as num?)?.toInt()
      ..transactionId = (json['transaction_id'] as num?)?.toInt()
      ..transactionQuantity = (json['transaction_quantity'] as num?)?.toInt()
      ..supplierName = json['supplier_name'] as String?
      ..supplierCnpj = json['supplier_cnpj'] as String?
      ..documentNumber = json['document_number'] as String?
      ..status = json['status'] as String?
      ..statusDescription = json['status_description'] as String?
      ..type = json['type'] as String?
      ..sendType = json['send_type'] as String?
      ..releaseDate = json['release_date'] as String?
      ..dueDate = json['due_date'] as String?
      ..withdrawalDate = json['withdrawal_date'] as String?
      ..value = (json['value'] as num?)?.toDouble()
      ..totalValue = (json['total_value'] as num?)?.toDouble()
      ..checkNumber = json['check_number'] as String?
      ..typeCode = json['type_code'] as String?
      ..account = json['account'] as String?
      ..ledgerAccountDescription = json['ledger_account_description'] as String?
      ..historical = json['historical'] as String?
      ..receiptFlag = json['receipt_flag'] as bool?
      ..inss = (json['inss'] as num?)?.toDouble()
      ..csll = (json['csll'] as num?)?.toDouble()
      ..irrf = (json['irrf'] as num?)?.toDouble()
      ..iss = (json['iss'] as num?)?.toDouble();

Map<String, dynamic> _$ContasPagarModelToJson(ContasPagarModel instance) =>
    <String, dynamic>{
      'installment_id': instance.installmentId,
      'supplier_id': instance.supplierId,
      'transaction_id': instance.transactionId,
      'transaction_quantity': instance.transactionQuantity,
      'supplier_name': instance.supplierName,
      'supplier_cnpj': instance.supplierCnpj,
      'document_number': instance.documentNumber,
      'status': instance.status,
      'status_description': instance.statusDescription,
      'type': instance.type,
      'send_type': instance.sendType,
      'release_date': instance.releaseDate,
      'due_date': instance.dueDate,
      'withdrawal_date': instance.withdrawalDate,
      'value': instance.value,
      'total_value': instance.totalValue,
      'check_number': instance.checkNumber,
      'type_code': instance.typeCode,
      'account': instance.account,
      'ledger_account_description': instance.ledgerAccountDescription,
      'historical': instance.historical,
      'receipt_flag': instance.receiptFlag,
      'inss': instance.inss,
      'csll': instance.csll,
      'irrf': instance.irrf,
      'iss': instance.iss,
    };
