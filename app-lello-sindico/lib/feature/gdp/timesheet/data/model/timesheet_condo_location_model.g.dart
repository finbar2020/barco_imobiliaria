// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_condo_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondoLocationModel _$CondoLocationModelFromJson(Map<String, dynamic> json) =>
    CondoLocationModel(
      reference: json['reference'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$CondoLocationModelToJson(CondoLocationModel instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
