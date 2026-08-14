// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LancamentoModel _$LancamentoModelFromJson(Map<String, dynamic> json) =>
    LancamentoModel()
      ..transactionId = (json['transaction_id'] as num?)?.toInt()
      ..supplier = json['supplier'] == null
          ? null
          : InstallmentSupplierModel.fromJson(
              json['supplier'] as Map<String, dynamic>)
      ..approvers = (json['approvers'] as List<dynamic>?)
          ?.map((e) =>
              InstallmentApproverModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..ledgerAccount = json['ledger_account'] == null
          ? null
          : InstallmentLedgerAccountModel.fromJson(
              json['ledger_account'] as Map<String, dynamic>)
      ..status = json['status'] as String?
      ..registrationDate = json['registration_date'] as String?
      ..documentNumber = json['document_number'] as String?
      ..totalValue = (json['total_value'] as num?)?.toDouble()
      ..dueDate = json['due_date'] as String?
      ..approverId1 = (json['approver_id1'] as num?)?.toInt()
      ..approverId2 = (json['approver_id2'] as num?)?.toInt()
      ..approverId3 = (json['approver_id3'] as num?)?.toInt()
      ..netValue = (json['net_value'] as num?)?.toDouble();

Map<String, dynamic> _$LancamentoModelToJson(LancamentoModel instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'supplier': instance.supplier,
      'approvers': instance.approvers,
      'ledger_account': instance.ledgerAccount,
      'status': instance.status,
      'registration_date': instance.registrationDate,
      'document_number': instance.documentNumber,
      'total_value': instance.totalValue,
      'due_date': instance.dueDate,
      'approver_id1': instance.approverId1,
      'approver_id2': instance.approverId2,
      'approver_id3': instance.approverId3,
      'net_value': instance.netValue,
    };
