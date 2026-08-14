// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlDateModel _$AccessControlDateModelFromJson(
        Map<String, dynamic> json) =>
    AccessControlDateModel(
      hour: (json['hour'] as num?)?.toInt(),
      minute: (json['minute'] as num?)?.toInt(),
      aecond: (json['aecond'] as num?)?.toInt(),
      nano: (json['nano'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccessControlDateModelToJson(
        AccessControlDateModel instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
      'aecond': instance.aecond,
      'nano': instance.nano,
    };
