// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_created_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementCreatedModel _$AgreementCreatedModelFromJson(
        Map<String, dynamic> json) =>
    AgreementCreatedModel(
      unit: json['unit'] as String? ?? "",
      paymentMethod: (json['payment_method'] as num?)?.toInt() ?? 0,
      installmentQuantity: (json['installment_quantity'] as num?)?.toInt() ?? 0,
      dueDate: (json['due_date'] as num?)?.toInt() ?? 0,
      reference: (json['reference'] as num?)?.toInt() ?? 0,
      receiptList: (json['receipt_list'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      email: json['email'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
    );

Map<String, dynamic> _$AgreementCreatedModelToJson(
        AgreementCreatedModel instance) =>
    <String, dynamic>{
      'unit': instance.unit,
      'payment_method': instance.paymentMethod,
      'installment_quantity': instance.installmentQuantity,
      'due_date': instance.dueDate,
      'reference': instance.reference,
      'receipt_list': instance.receiptList,
      'email': instance.email,
      'phone': instance.phone,
    };
