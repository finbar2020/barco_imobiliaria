// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentFileModel _$DocumentFileModelFromJson(Map<String, dynamic> json) =>
    DocumentFileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$DocumentFileModelToJson(DocumentFileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'data': instance.data,
    };
