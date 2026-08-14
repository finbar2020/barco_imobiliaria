// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_recommendation_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementRecommendationPaymentModel
    _$AgreementRecommendationPaymentModelFromJson(Map<String, dynamic> json) =>
        AgreementRecommendationPaymentModel(
          paymentMethod: json['payment_method'] as String?,
          dueDay: (json['due_day'] as num?)?.toInt(),
          installmentQtd: (json['installment_qtd'] as num).toInt(),
          recomendation: json['recomendation'] as bool,
        );

Map<String, dynamic> _$AgreementRecommendationPaymentModelToJson(
        AgreementRecommendationPaymentModel instance) =>
    <String, dynamic>{
      'payment_method': instance.paymentMethod,
      'due_day': instance.dueDay,
      'installment_qtd': instance.installmentQtd,
      'recomendation': instance.recomendation,
    };
