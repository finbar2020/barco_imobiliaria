// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_doubt_request_attachments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentsRequestModel _$AttachmentsRequestModelFromJson(
        Map<String, dynamic> json) =>
    AttachmentsRequestModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      file: json['file'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$AttachmentsRequestModelToJson(
        AttachmentsRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'file': instance.file,
      'content': instance.content,
    };
