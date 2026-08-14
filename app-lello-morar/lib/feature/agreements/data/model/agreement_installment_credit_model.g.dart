// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_installment_credit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementInstallmentCreditModel _$AgreementInstallmentCreditModelFromJson(
        Map<String, dynamic> json) =>
    AgreementInstallmentCreditModel(
      billetValue: (json['billet_value'] as num).toDouble(),
      installmentQtd: (json['installment_qtd'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      totalValue: (json['total_value'] as num).toDouble(),
      installmentValue: (json['installment_value'] as num).toDouble(),
      cetMonth: json['cet_month'] as String?,
      cetTotal: json['cet_total'] as String?,
      creditTax: json['credit_tax'] as String?,
      creditTaxValue: (json['credit_tax_value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AgreementInstallmentCreditModelToJson(
        AgreementInstallmentCreditModel instance) =>
    <String, dynamic>{
      'billet_value': instance.billetValue,
      'installment_qtd': instance.installmentQtd,
      'tax': instance.tax,
      'total_value': instance.totalValue,
      'installment_value': instance.installmentValue,
      'cet_month': instance.cetMonth,
      'cet_total': instance.cetTotal,
      'credit_tax': instance.creditTax,
      'credit_tax_value': instance.creditTaxValue,
    };
