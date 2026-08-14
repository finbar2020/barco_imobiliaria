// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementRuleModel _$AgreementRuleModelFromJson(Map<String, dynamic> json) =>
    AgreementRuleModel(
      installmentQtd: (json['installment_qtd'] as num).toInt(),
      days: (json['days'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      paymentMethod: (json['payment_method'] as List<dynamic>)
          .map((e) =>
              AgreementPaymentMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgreementRuleModelToJson(AgreementRuleModel instance) =>
    <String, dynamic>{
      'installment_qtd': instance.installmentQtd,
      'days': instance.days,
      'payment_method': instance.paymentMethod,
    };
