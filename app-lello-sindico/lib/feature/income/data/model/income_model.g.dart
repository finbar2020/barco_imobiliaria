// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeModel _$IncomeModelFromJson(Map<String, dynamic> json) => IncomeModel(
      period: json['period'] as String?,
      shares: (json['shares'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : IncomeShareModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      forecast: (json['forecast'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : IncomeForecastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pendingBillets: (json['pending_billets'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : BilletModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      value: (json['value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$IncomeModelToJson(IncomeModel instance) =>
    <String, dynamic>{
      'period': instance.period,
      'shares': instance.shares,
      'forecast': instance.forecast,
      'pending_billets': instance.pendingBillets,
      'value': instance.value,
    };
