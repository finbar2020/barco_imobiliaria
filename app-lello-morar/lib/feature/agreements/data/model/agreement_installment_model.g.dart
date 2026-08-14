// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_installment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementInstallmentModel _$AgreementInstallmentModelFromJson(
        Map<String, dynamic> json) =>
    AgreementInstallmentModel(
      readableLine: json['readable_line'] as String?,
      barCode: json['bar_code'] as String?,
      installmentId: json['installment_id'] as String?,
      recnum: json['recnum'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      status: json['status'] as String?,
      paymentLink: json['payment_link'] as String?,
    );

Map<String, dynamic> _$AgreementInstallmentModelToJson(
        AgreementInstallmentModel instance) =>
    <String, dynamic>{
      'readable_line': instance.readableLine,
      'bar_code': instance.barCode,
      'installment_id': instance.installmentId,
      'recnum': instance.recnum,
      'value': instance.value,
      'due_date': instance.dueDate?.toIso8601String(),
      'status': instance.status,
      'payment_link': instance.paymentLink,
    };
