// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationTimeModel _$ReservationTimeModelFromJson(
        Map<String, dynamic> json) =>
    ReservationTimeModel()
      ..from =
          json['from'] == null ? null : DateTime.parse(json['from'] as String)
      ..to = json['to'] == null ? null : DateTime.parse(json['to'] as String);

Map<String, dynamic> _$ReservationTimeModelToJson(
        ReservationTimeModel instance) =>
    <String, dynamic>{
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
    };
