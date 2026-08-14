// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_bella_rate_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IaBellaRateResponseModel _$IaBellaRateResponseModelFromJson(
        Map<String, dynamic> json) =>
    IaBellaRateResponseModel(
      responseId: json['response_id'] as String?,
      evaluationType: json['evaluation_type'] as String?,
      justification: json['justification'] as String?,
    );

Map<String, dynamic> _$IaBellaRateResponseModelToJson(
        IaBellaRateResponseModel instance) =>
    <String, dynamic>{
      'response_id': instance.responseId,
      'evaluation_type': instance.evaluationType,
      'justification': instance.justification,
    };
