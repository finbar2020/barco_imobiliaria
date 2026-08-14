// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementPaymentMethodModel _$AgreementPaymentMethodModelFromJson(
        Map<String, dynamic> json) =>
    AgreementPaymentMethodModel(
      type: $enumDecode(_$AgreementPaymentMethodEnumEnumMap, json['type']),
      enabled: json['enabled'] as bool,
      text: json['text'] as String,
      description: json['description'] as String,
      disabledDescription: json['disabled_description'] as String,
    );

Map<String, dynamic> _$AgreementPaymentMethodModelToJson(
        AgreementPaymentMethodModel instance) =>
    <String, dynamic>{
      'type': _$AgreementPaymentMethodEnumEnumMap[instance.type]!,
      'enabled': instance.enabled,
      'text': instance.text,
      'description': instance.description,
      'disabled_description': instance.disabledDescription,
    };

const _$AgreementPaymentMethodEnumEnumMap = {
  AgreementPaymentMethodEnum.credit: 'credit',
  AgreementPaymentMethodEnum.billet: 'billet',
  AgreementPaymentMethodEnum.undef: 'undef',
};
