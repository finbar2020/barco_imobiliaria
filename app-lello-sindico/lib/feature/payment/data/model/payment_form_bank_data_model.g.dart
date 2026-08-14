// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_form_bank_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentFormBankDataModel _$PaymentFormBankDataModelFromJson(
        Map<String, dynamic> json) =>
    PaymentFormBankDataModel(
      bank: json['bank'] == null
          ? null
          : BankModel.fromJson(json['bank'] as Map<String, dynamic>),
      agency: json['agency'] as String?,
      account: json['account'] as String?,
      digit: json['digit'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$PaymentFormBankDataModelToJson(
        PaymentFormBankDataModel instance) =>
    <String, dynamic>{
      'bank': instance.bank,
      'agency': instance.agency,
      'account': instance.account,
      'digit': instance.digit,
      'type': instance.type,
    };
