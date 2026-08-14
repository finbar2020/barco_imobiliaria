// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentsResponseModel _$DocumentsResponseModelFromJson(
        Map<String, dynamic> json) =>
    DocumentsResponseModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..content = json['content'] as String?
      ..createdAt = json['created_at'] as String?
      ..flagEmailDistribution = json['flag_email_distribution'] as bool?
      ..flagPrintDistribution = json['flag_print_distribution'] as bool?
      ..pagesQuantity = (json['pages_quantity'] as num?)?.toInt()
      ..status = json['status'] as String?
      ..notificationParameter = json['notification_parameter'] as String?
      ..documentsType =
          $enumDecodeNullable(_$DocumentsTypeEnumMap, json['documents_type']);

Map<String, dynamic> _$DocumentsResponseModelToJson(
        DocumentsResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'content': instance.content,
      'created_at': instance.createdAt,
      'flag_email_distribution': instance.flagEmailDistribution,
      'flag_print_distribution': instance.flagPrintDistribution,
      'pages_quantity': instance.pagesQuantity,
      'status': instance.status,
      'notification_parameter': instance.notificationParameter,
      'documents_type': _$DocumentsTypeEnumMap[instance.documentsType],
    };

const _$DocumentsTypeEnumMap = {
  DocumentsType.main: 'main',
  DocumentsType.atas: 'atas',
  DocumentsType.editais: 'editais',
  DocumentsType.circulares: 'circulares',
  DocumentsType.outros: 'outros',
};
