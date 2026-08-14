// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_fcm_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterFcmTokenModel _$RegisterFcmTokenModelFromJson(
        Map<String, dynamic> json) =>
    RegisterFcmTokenModel()
      ..token = json['token'] as String?
      ..reference = (json['reference'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..type = json['type'] as String?
      ..deviceId = json['device_id'] as String?
      ..refreshToken = json['refresh_token'] as String?;

Map<String, dynamic> _$RegisterFcmTokenModelToJson(
        RegisterFcmTokenModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'reference': instance.reference,
      'type': instance.type,
      'device_id': instance.deviceId,
      'refresh_token': instance.refreshToken,
    };
