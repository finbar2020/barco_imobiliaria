// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_legal_obligation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadLegalObligationResponseModel _$UploadLegalObligationResponseModelFromJson(
        Map<String, dynamic> json) =>
    UploadLegalObligationResponseModel(
      link: json['link'] as String?,
      success: json['success'] as bool,
      errorCode: json['error_code'] as String?,
    );

Map<String, dynamic> _$UploadLegalObligationResponseModelToJson(
        UploadLegalObligationResponseModel instance) =>
    <String, dynamic>{
      'link': instance.link,
      'success': instance.success,
      'error_code': instance.errorCode,
    };
