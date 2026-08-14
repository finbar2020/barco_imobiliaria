// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_upload_s3_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UrlUploadS3Model _$UrlUploadS3ModelFromJson(Map<String, dynamic> json) =>
    UrlUploadS3Model(
      fileName: json['file_name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$UrlUploadS3ModelToJson(UrlUploadS3Model instance) =>
    <String, dynamic>{
      'file_name': instance.fileName,
      'url': instance.url,
    };
