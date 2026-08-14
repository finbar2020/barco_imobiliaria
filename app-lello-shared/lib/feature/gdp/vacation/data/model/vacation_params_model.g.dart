// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationParamsModel _$VacationParamsModelFromJson(Map<String, dynamic> json) =>
    VacationParamsModel(
      gdpVacationPeriods: (json['gdp_vacation_periods'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : VacationPeriodModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      gdpVacationInitDays:
          (json['gdp_vacation_init_days'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VacationParamsModelToJson(
        VacationParamsModel instance) =>
    <String, dynamic>{
      'gdp_vacation_periods': instance.gdpVacationPeriods,
      'gdp_vacation_init_days': instance.gdpVacationInitDays,
    };
