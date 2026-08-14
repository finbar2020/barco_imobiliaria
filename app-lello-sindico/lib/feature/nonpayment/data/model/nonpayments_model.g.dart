// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonpayments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NonPaymentModel _$NonPaymentModelFromJson(Map<String, dynamic> json) =>
    NonPaymentModel(
      positionOfDay: json['position_of_day'] == null
          ? null
          : DateTime.parse(json['position_of_day'] as String),
      quotes: (json['quotes'] as num?)?.toInt(),
      value: (json['value'] as num?)?.toDouble(),
      valueWithPenalty: (json['value_with_penalty'] as num?)?.toDouble(),
      penalty: (json['penalty'] as num?)?.toDouble(),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : NonPaymentsDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NonPaymentModelToJson(NonPaymentModel instance) =>
    <String, dynamic>{
      'position_of_day': instance.positionOfDay?.toIso8601String(),
      'quotes': instance.quotes,
      'value': instance.value,
      'value_with_penalty': instance.valueWithPenalty,
      'penalty': instance.penalty,
      'details': instance.details,
    };
