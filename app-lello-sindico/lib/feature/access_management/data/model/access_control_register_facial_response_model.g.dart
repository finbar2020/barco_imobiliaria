// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_register_facial_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlRegisterFacialResponseModel
    _$AccessControlRegisterFacialResponseModelFromJson(
            Map<String, dynamic> json) =>
        AccessControlRegisterFacialResponseModel(
          status: json['status'] as String?,
          message: json['message'] as String?,
          codigo: json['codigo'] as String?,
          success: json['success'] as bool?,
          timestamp: json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
        );

Map<String, dynamic> _$AccessControlRegisterFacialResponseModelToJson(
        AccessControlRegisterFacialResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'codigo': instance.codigo,
      'success': instance.success,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
