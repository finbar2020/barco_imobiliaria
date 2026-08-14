// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentAttachmentModel _$DocumentAttachmentModelFromJson(
        Map<String, dynamic> json) =>
    DocumentAttachmentModel(
      type: json['type'] as String?,
      content: json['content'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$DocumentAttachmentModelToJson(
        DocumentAttachmentModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'name': instance.name,
    };
