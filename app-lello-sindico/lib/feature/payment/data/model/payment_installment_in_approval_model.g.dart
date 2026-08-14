// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_installment_in_approval_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInstallmentInApprovalModel _$PaymentInstallmentInApprovalModelFromJson(
        Map<String, dynamic> json) =>
    PaymentInstallmentInApprovalModel(
      installmentId: (json['installment_id'] as num?)?.toInt(),
      dueDate: json['due_date'] as String?,
      installment: json['installment'] == null
          ? null
          : LancamentoModel.fromJson(
              json['installment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentInstallmentInApprovalModelToJson(
        PaymentInstallmentInApprovalModel instance) =>
    <String, dynamic>{
      'installment_id': instance.installmentId,
      'due_date': instance.dueDate,
      'installment': instance.installment,
    };
