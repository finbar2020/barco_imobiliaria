// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_installments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInstallmentsModel _$PaymentInstallmentsModelFromJson(
        Map<String, dynamic> json) =>
    PaymentInstallmentsModel()
      ..value = (json['value'] as num?)?.toDouble()
      ..dueDate = json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String);

Map<String, dynamic> _$PaymentInstallmentsModelToJson(
        PaymentInstallmentsModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'due_date': instance.dueDate?.toIso8601String(),
    };
