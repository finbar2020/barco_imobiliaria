// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementModel _$AgreementModelFromJson(Map<String, dynamic> json) =>
    AgreementModel(
      id: json['id'] as String?,
      reference: (json['reference'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String?,
      unitOwner: json['unit_owner'] as String?,
      baseValue: (json['base_value'] as num?)?.toDouble() ?? 0.0,
      fineAndCosts: (json['fine_and_costs'] as num?)?.toDouble() ?? 0.0,
      installmentQuantity: (json['installment_quantity'] as num?)?.toInt() ?? 0,
      paymentMethod: json['payment_method'] as String?,
      status: json['status'] as String?,
      statusMessage: json['status_message'] as String?,
      expiration: json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String),
      proposaldedDate: json['proposalded_date'] == null
          ? null
          : DateTime.parse(json['proposalded_date'] as String),
      approvalDate: json['approval_date'] == null
          ? null
          : DateTime.parse(json['approval_date'] as String),
      dueDate: (json['due_date'] as num?)?.toInt() ?? 0,
      lastInstallmentDate: json['last_installment_date'] == null
          ? null
          : DateTime.parse(json['last_installment_date'] as String),
      installments: (json['installments'] as List<dynamic>?)
              ?.map((e) =>
                  AgreementInstallmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      quotes: (json['quotes'] as List<dynamic>?)
              ?.map((e) =>
                  AgreementQuoteModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notificationParameter: json['notification_parameter'] as String?,
    );

Map<String, dynamic> _$AgreementModelToJson(AgreementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'unit': instance.unit,
      'unit_owner': instance.unitOwner,
      'base_value': instance.baseValue,
      'fine_and_costs': instance.fineAndCosts,
      'installment_quantity': instance.installmentQuantity,
      'payment_method': instance.paymentMethod,
      'status': instance.status,
      'status_message': instance.statusMessage,
      'expiration': instance.expiration?.toIso8601String(),
      'proposalded_date': instance.proposaldedDate?.toIso8601String(),
      'approval_date': instance.approvalDate?.toIso8601String(),
      'due_date': instance.dueDate,
      'last_installment_date': instance.lastInstallmentDate?.toIso8601String(),
      'installments': instance.installments,
      'quotes': instance.quotes,
      'notification_parameter': instance.notificationParameter,
    };
