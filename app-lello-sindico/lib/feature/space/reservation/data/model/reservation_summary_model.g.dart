// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationSummaryModel _$ReservationSummaryModelFromJson(
        Map<String, dynamic> json) =>
    ReservationSummaryModel()
      ..day = json['day'] == null ? null : DateTime.parse(json['day'] as String)
      ..types =
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$ReservationSummaryModelToJson(
        ReservationSummaryModel instance) =>
    <String, dynamic>{
      'day': instance.day?.toIso8601String(),
      'types': instance.types,
    };
