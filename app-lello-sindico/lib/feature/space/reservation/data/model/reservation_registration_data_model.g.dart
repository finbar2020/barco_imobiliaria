// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_registration_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRegistrationDataModel _$ReservationRegistrationDataModelFromJson(
        Map<String, dynamic> json) =>
    ReservationRegistrationDataModel()
      ..spaceId = json['space_id'] as String?
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..dateTo = json['date_to'] == null
          ? null
          : DateTime.parse(json['date_to'] as String)
      ..type = json['type'] as String?
      ..unitId = json['unit_id'] as String?;

Map<String, dynamic> _$ReservationRegistrationDataModelToJson(
        ReservationRegistrationDataModel instance) =>
    <String, dynamic>{
      'space_id': instance.spaceId,
      'date': instance.date?.toIso8601String(),
      'date_to': instance.dateTo?.toIso8601String(),
      'type': instance.type,
      'unit_id': instance.unitId,
    };
