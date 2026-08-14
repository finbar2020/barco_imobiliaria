// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_period_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationPeriodModel _$VacationPeriodModelFromJson(Map<String, dynamic> json) =>
    VacationPeriodModel(
      gdpPeriodAmount: (json['gdp_period_amount'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : VacationPeriodIntervalModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      gdpPeriodVacation: (json['gdp_period_vacation'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VacationPeriodModelToJson(
        VacationPeriodModel instance) =>
    <String, dynamic>{
      'gdp_period_amount': instance.gdpPeriodAmount,
      'gdp_period_vacation': instance.gdpPeriodVacation,
    };
