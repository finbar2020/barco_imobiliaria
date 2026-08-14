// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentModel _$InstallmentModelFromJson(Map<String, dynamic> json) =>
    InstallmentModel(
      id: (json['id'] as num?)?.toInt(),
      dueDate: DateTime.parse(json['due_date'] as String),
      value: (json['value'] as num).toDouble(),
      paymentFormId: (json['payment_form_id'] as num?)?.toInt(),
      paymentTypeId: (json['payment_type_id'] as num?)?.toInt(),
      agency: json['agency'] as String?,
      bankId: (json['bank_id'] as num?)?.toInt(),
      accountDigit: json['account_digit'] as String?,
      accountNumber: json['account_number'] as String?,
      accountType: json['account_type'] as String?,
    );

Map<String, dynamic> _$InstallmentModelToJson(InstallmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'due_date': instance.dueDate.toIso8601String(),
      'value': instance.value,
      'payment_form_id': instance.paymentFormId,
      'payment_type_id': instance.paymentTypeId,
      'agency': instance.agency,
      'bank_id': instance.bankId,
      'account_digit': instance.accountDigit,
      'account_number': instance.accountNumber,
      'account_type': instance.accountType,
    };
