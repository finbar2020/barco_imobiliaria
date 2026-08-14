// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementModel _$AgreementModelFromJson(Map<String, dynamic> json) =>
    AgreementModel(
      id: json['id'] as String,
      unit: json['unit'] as String,
      unitOwner: json['unit_owner'] as String,
      baseValue: (json['base_value'] as num).toDouble(),
      fineAndCosts: (json['fine_and_costs'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      expiration: json['expiration'] as String,
      installmentQuantity: (json['installment_quantity'] as num).toInt(),
      proposaldedDate: json['proposalded_date'] as String,
      approvalDate: json['approval_date'] as String?,
      agreementCodeAcob: json['agreement_code_acob'] as String?,
      reference: (json['reference'] as num).toInt(),
      lastInstallmentDate: json['last_installment_date'] == null
          ? null
          : DateTime.parse(json['last_installment_date'] as String),
      status: json['status'] as String,
      statusMessage: json['status_message'] as String,
      installments: (json['installments'] as List<dynamic>)
          .map((e) =>
              AgreementInstallmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      quotes: (json['quotes'] as List<dynamic>)
          .map((e) => AgreementQuotaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reason: json['reason'] as String?,
      notificationParameter: json['notification_parameter'] as String?,
    );

Map<String, dynamic> _$AgreementModelToJson(AgreementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit': instance.unit,
      'unit_owner': instance.unitOwner,
      'base_value': instance.baseValue,
      'fine_and_costs': instance.fineAndCosts,
      'payment_method': instance.paymentMethod,
      'expiration': instance.expiration,
      'installment_quantity': instance.installmentQuantity,
      'proposalded_date': instance.proposaldedDate,
      'approval_date': instance.approvalDate,
      'agreement_code_acob': instance.agreementCodeAcob,
      'reference': instance.reference,
      'last_installment_date': instance.lastInstallmentDate?.toIso8601String(),
      'status': instance.status,
      'status_message': instance.statusMessage,
      'installments': instance.installments,
      'quotes': instance.quotes,
      'reason': instance.reason,
      'notification_parameter': instance.notificationParameter,
    };
