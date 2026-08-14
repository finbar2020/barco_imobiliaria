// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_period_interval_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationPeriodIntervalModel _$VacationPeriodIntervalModelFromJson(
        Map<String, dynamic> json) =>
    VacationPeriodIntervalModel(
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      allowence: (json['allowence'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VacationPeriodIntervalModelToJson(
        VacationPeriodIntervalModel instance) =>
    <String, dynamic>{
      'days': instance.days,
      'allowence': instance.allowence,
    };
