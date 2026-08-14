// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_start_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IaStartSessionModel _$IaStartSessionModelFromJson(Map<String, dynamic> json) =>
    IaStartSessionModel(
      timestamp: json['timestamp'] as String?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : IaBellaDataModel.fromJson(json['data'] as Map<String, dynamic>),
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$IaStartSessionModelToJson(
        IaStartSessionModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'status_code': instance.statusCode,
      'data': instance.data,
      'error_message': instance.errorMessage,
    };
