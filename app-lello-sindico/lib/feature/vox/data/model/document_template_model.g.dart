// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentTemplateModel _$DocumentTemplateModelFromJson(
        Map<String, dynamic> json) =>
    DocumentTemplateModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..group = json['group'] as String?
      ..thumbnail = json['thumbnail'] as String?;

Map<String, dynamic> _$DocumentTemplateModelToJson(
        DocumentTemplateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'group': instance.group,
      'thumbnail': instance.thumbnail,
    };
