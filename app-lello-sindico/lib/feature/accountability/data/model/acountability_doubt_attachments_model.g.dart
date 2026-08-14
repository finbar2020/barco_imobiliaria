// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_doubt_attachments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentsModel _$AttachmentsModelFromJson(Map<String, dynamic> json) =>
    AttachmentsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      fileName: json['file_name'] as String?,
    );

Map<String, dynamic> _$AttachmentsModelToJson(AttachmentsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'file_name': instance.fileName,
    };
