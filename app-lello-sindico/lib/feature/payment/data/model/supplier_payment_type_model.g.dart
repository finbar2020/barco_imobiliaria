// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_payment_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierPaymentTypeModel _$SupplierPaymentTypeModelFromJson(
        Map<String, dynamic> json) =>
    SupplierPaymentTypeModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      paymentForms: (json['payment_forms'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : PaymentFormModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SupplierPaymentTypeModelToJson(
        SupplierPaymentTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'payment_forms': instance.paymentForms,
    };
