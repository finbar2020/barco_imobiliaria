// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_days_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarDaysResponseModel _$CalendarDaysResponseModelFromJson(
        Map<String, dynamic> json) =>
    CalendarDaysResponseModel(
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      days: (json['days'] as List<dynamic>)
          .map((e) => CalendarDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CalendarDaysResponseModelToJson(
        CalendarDaysResponseModel instance) =>
    <String, dynamic>{
      'month': instance.month,
      'year': instance.year,
      'days': instance.days,
    };
