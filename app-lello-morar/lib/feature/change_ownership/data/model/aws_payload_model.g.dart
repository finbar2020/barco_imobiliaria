// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aws_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AwsPayloadModel _$AwsPayloadModelFromJson(Map<String, dynamic> json) =>
    AwsPayloadModel(
      fileName: json['file_name'] as String?,
      bucket: json['bucket'] as String?,
      httpMethod: json['http_method'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$AwsPayloadModelToJson(AwsPayloadModel instance) =>
    <String, dynamic>{
      'file_name': instance.fileName,
      'bucket': instance.bucket,
      'http_method': instance.httpMethod,
      'url': instance.url,
    };
