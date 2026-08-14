// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentFormModel _$PaymentFormModelFromJson(Map<String, dynamic> json) =>
    PaymentFormModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      bankData: json['bank_data'] == null
          ? null
          : PaymentFormBankDataModel.fromJson(
              json['bank_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentFormModelToJson(PaymentFormModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bank_data': instance.bankData,
    };
