// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) =>
    ReservationModel()
      ..id = json['id'] as String?
      ..type = json['type'] as String?
      ..from =
          json['from'] == null ? null : DateTime.parse(json['from'] as String)
      ..to = json['to'] == null ? null : DateTime.parse(json['to'] as String)
      ..expiration = json['expiration'] == null
          ? null
          : DateTime.parse(json['expiration'] as String)
      ..space = json['space'] == null
          ? null
          : SpaceModel.fromJson(json['space'] as Map<String, dynamic>)
      ..unit = json['unit'] == null
          ? null
          : UnitModel.fromJson(json['unit'] as Map<String, dynamic>)
      ..price = (json['price'] as num?)?.toDouble()
      ..receipt = json['receipt'] as String?
      ..cancellationLimit = json['cancellation_limit'] == null
          ? null
          : DateTime.parse(json['cancellation_limit'] as String)
      ..status = json['status'] as String?;

Map<String, dynamic> _$ReservationModelToJson(ReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'expiration': instance.expiration?.toIso8601String(),
      'space': instance.space,
      'unit': instance.unit,
      'price': instance.price,
      'receipt': instance.receipt,
      'cancellation_limit': instance.cancellationLimit?.toIso8601String(),
      'status': instance.status,
    };
