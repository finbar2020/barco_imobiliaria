// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_form_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitFormResponseModel _$SubmitFormResponseModelFromJson(
        Map<String, dynamic> json) =>
    SubmitFormResponseModel(
      success: json['success'] as bool,
      message: json['detail'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$SubmitFormResponseModelToJson(
        SubmitFormResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'detail': instance.message,
      'data': instance.data,
    };
