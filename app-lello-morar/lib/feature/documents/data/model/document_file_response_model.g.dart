// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_file_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentFileResponseModel _$DocumentFileResponseModelFromJson(
        Map<String, dynamic> json) =>
    DocumentFileResponseModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..type = json['type'] as String?
      ..data = json['data'] as String?
      ..extractedText = json['extractedText'] as String?;

Map<String, dynamic> _$DocumentFileResponseModelToJson(
        DocumentFileResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'data': instance.data,
      'extractedText': instance.extractedText,
    };
