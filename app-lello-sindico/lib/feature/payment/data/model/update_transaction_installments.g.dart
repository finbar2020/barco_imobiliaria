// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_installments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionInstallments _$UpdateTransactionInstallmentsFromJson(
        Map<String, dynamic> json) =>
    UpdateTransactionInstallments(
      transactionId: (json['transaction_id'] as num?)?.toInt(),
      installmentId: (json['installment_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpdateTransactionInstallmentsToJson(
        UpdateTransactionInstallments instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'installment_id': instance.installmentId,
    };
