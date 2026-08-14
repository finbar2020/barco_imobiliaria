// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_access_request_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAccessRequestStatusModel _$UpdateAccessRequestStatusModelFromJson(
        Map<String, dynamic> json) =>
    UpdateAccessRequestStatusModel(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$UpdateAccessRequestStatusModelToJson(
        UpdateAccessRequestStatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
