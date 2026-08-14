// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeForecastModel _$IncomeForecastModelFromJson(Map<String, dynamic> json) =>
    IncomeForecastModel(
      period: json['period'] as String?,
      forecast: (json['forecast'] as num?)?.toDouble(),
      value: (json['value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$IncomeForecastModelToJson(
        IncomeForecastModel instance) =>
    <String, dynamic>{
      'period': instance.period,
      'forecast': instance.forecast,
      'value': instance.value,
    };
