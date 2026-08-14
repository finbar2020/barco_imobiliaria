// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_installment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementInstallmentModel _$AgreementInstallmentModelFromJson(
        Map<String, dynamic> json) =>
    AgreementInstallmentModel(
      installmentId: json['installment_id'] as String?,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$AgreementInstallmentModelToJson(
        AgreementInstallmentModel instance) =>
    <String, dynamic>{
      'installment_id': instance.installmentId,
      'value': instance.value,
      'due_date': instance.dueDate?.toIso8601String(),
      'status': instance.status,
    };
