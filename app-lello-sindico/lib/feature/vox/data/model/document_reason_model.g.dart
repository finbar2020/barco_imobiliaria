// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_reason_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentReasonModel _$DocumentReasonModelFromJson(Map<String, dynamic> json) =>
    DocumentReasonModel()
      ..id = json['id'] as String?
      ..description = json['description'] as String?
      ..keywords = json['keywords'] as String?
      ..updatedAt = json['updated_at'] as String?
      ..userId = json['user_id'] as String?
      ..flagActive = json['flag_active'] as bool?;

Map<String, dynamic> _$DocumentReasonModelToJson(
        DocumentReasonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'keywords': instance.keywords,
      'updated_at': instance.updatedAt,
      'user_id': instance.userId,
      'flag_active': instance.flagActive,
    };
