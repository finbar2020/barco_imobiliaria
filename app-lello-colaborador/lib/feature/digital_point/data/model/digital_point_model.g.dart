// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitalPointModel _$DigitalPointModelFromJson(Map<String, dynamic> json) =>
    DigitalPointModel(
      id: (json['id'] as num?)?.toInt(),
      date: DateTime.parse(json['date'] as String),
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      typePoint: json['type_point'] as String,
      photoPath: json['photo_path'] as String,
      status: json['status'] as String,
      typeCapture: json['type_capture'] as String,
      uniqueHash: json['unique_hash'] as String,
      tabletSession: json['tablet_session'] as bool?,
      photoTempHash: json['photo_temp_hash'] as String?,
      reference: json['reference'] as String?,
      numCra: json['num_cra'] as String?,
      numCad: json['num_cad'] as String?,
    );

Map<String, dynamic> _$DigitalPointModelToJson(DigitalPointModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'photo_path': instance.photoPath,
      'photo_temp_hash': instance.photoTempHash,
      'type_point': instance.typePoint,
      'type_capture': instance.typeCapture,
      'status': instance.status,
      'unique_hash': instance.uniqueHash,
      'tablet_session': instance.tabletSession,
      'reference': instance.reference,
      'num_cra': instance.numCra,
      'num_cad': instance.numCad,
      'logs': DigitalPointModel._toJsonLogs(instance.logs),
    };
