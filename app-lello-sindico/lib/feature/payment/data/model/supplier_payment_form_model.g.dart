// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_payment_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierPaymentFormModel _$SupplierPaymentFormModelFromJson(
        Map<String, dynamic> json) =>
    SupplierPaymentFormModel()
      ..id = (json['id'] as num?)?.toInt()
      ..name = json['name'] as String?
      ..bankData = json['bank_data'] == null
          ? null
          : SupplierPaymentFormBankDataModel.fromJson(
              json['bank_data'] as Map<String, dynamic>);

Map<String, dynamic> _$SupplierPaymentFormModelToJson(
        SupplierPaymentFormModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bank_data': instance.bankData,
    };
