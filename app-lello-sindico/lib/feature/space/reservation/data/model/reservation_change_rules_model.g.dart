// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_change_rules_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationChangeRulesModel _$ReservationChangeRulesModelFromJson(
        Map<String, dynamic> json) =>
    ReservationChangeRulesModel(
      idMovingRule: json['id_moving_rule'] as String?,
      spaceId: json['space_id'] as String?,
      condominio: json['condominio'] == null
          ? null
          : CondominiumModel.fromJson(
              json['condominio'] as Map<String, dynamic>),
      weekHourStart: json['week_hour_start'] as String?,
      weekHourEnd: json['week_hour_end'] as String?,
      weekendHourStart: json['weekend_hour_start'] as String?,
      weekendHourEnd: json['weekend_hour_end'] as String?,
      daysInAdvance: (json['days_in_advance'] as num?)?.toInt(),
      allowedDays: (json['allowed_days'] as num?)?.toInt(),
      allowedDaysList: (json['allowed_days_list'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      maxPerDay: (json['max_per_day'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReservationChangeRulesModelToJson(
        ReservationChangeRulesModel instance) =>
    <String, dynamic>{
      'id_moving_rule': instance.idMovingRule,
      'space_id': instance.spaceId,
      'condominio': instance.condominio,
      'week_hour_start': instance.weekHourStart,
      'week_hour_end': instance.weekHourEnd,
      'weekend_hour_start': instance.weekendHourStart,
      'weekend_hour_end': instance.weekendHourEnd,
      'days_in_advance': instance.daysInAdvance,
      'allowed_days': instance.allowedDays,
      'allowed_days_list': instance.allowedDaysList,
      'max_per_day': instance.maxPerDay,
    };
