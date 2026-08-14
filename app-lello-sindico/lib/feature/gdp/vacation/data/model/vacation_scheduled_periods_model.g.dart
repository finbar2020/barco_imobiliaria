// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_scheduled_periods_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationScheduledPeriodsModel _$VacationScheduledPeriodsModelFromJson(
        Map<String, dynamic> json) =>
    VacationScheduledPeriodsModel(
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      scheduledDays: (json['scheduled_days'] as num?)?.toInt(),
      totalVacation: (json['total_vacation'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VacationScheduledPeriodsModelToJson(
        VacationScheduledPeriodsModel instance) =>
    <String, dynamic>{
      'start_date': instance.startDate?.toIso8601String(),
      'scheduled_days': instance.scheduledDays,
      'total_vacation': instance.totalVacation,
    };
