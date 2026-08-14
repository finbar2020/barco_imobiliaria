// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_calendar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceCalendarModel _$SpaceCalendarModelFromJson(Map<String, dynamic> json) =>
    SpaceCalendarModel(
      lockedDays: (json['locked_days'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      alreadyReservatedDays: (json['already_reservated_days'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      raffledDays: (json['raffled_days'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      freeToReserveDays: (json['free_to_reserve_days'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SpaceCalendarModelToJson(SpaceCalendarModel instance) =>
    <String, dynamic>{
      'locked_days': instance.lockedDays,
      'already_reservated_days': instance.alreadyReservatedDays,
      'raffled_days': instance.raffledDays,
      'free_to_reserve_days': instance.freeToReserveDays,
    };
