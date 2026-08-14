// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_locked_days_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationLockedDaysModel _$VacationLockedDaysModelFromJson(
        Map<String, dynamic> json) =>
    VacationLockedDaysModel(
      locked_days: (json['locked_days'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VacationLockedDaysModelToJson(
        VacationLockedDaysModel instance) =>
    <String, dynamic>{
      'locked_days': instance.locked_days,
    };
