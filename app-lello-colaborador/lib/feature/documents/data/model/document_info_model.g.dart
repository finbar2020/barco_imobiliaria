// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentInfoModel _$DocumentInfoModelFromJson(Map<String, dynamic> json) =>
    DocumentInfoModel(
      name: json['name'] as String,
      type: json['type'] as String,
      documentProcessingDate:
          DateTime.parse(json['document_processing_date'] as String),
    );

Map<String, dynamic> _$DocumentInfoModelToJson(DocumentInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'document_processing_date':
          instance.documentProcessingDate.toIso8601String(),
    };
