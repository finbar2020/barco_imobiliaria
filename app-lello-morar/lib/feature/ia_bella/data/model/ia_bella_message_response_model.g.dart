// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_bella_message_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IaBellaMessageResponseModel _$IaBellaMessageResponseModelFromJson(
        Map<String, dynamic> json) =>
    IaBellaMessageResponseModel(
      timestamp: json['timestamp'] as String?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : IaBellaDataModel.fromJson(json['data'] as Map<String, dynamic>),
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$IaBellaMessageResponseModelToJson(
        IaBellaMessageResponseModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'status_code': instance.statusCode,
      'data': instance.data,
      'error_message': instance.errorMessage,
    };
