// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FineModel _$FineModelFromJson(Map<String, dynamic> json) => FineModel()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..description = json['description'] as String?
  ..reason = json['reason'] as String?
  ..occurrenceDate = json['occurrence_date'] == null
      ? null
      : DateTime.parse(json['occurrence_date'] as String)
  ..content = json['content'] as String?
  ..createdAt = json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String)
  ..flagEmailDistribution = json['flag_email_distribution'] as bool?
  ..flagPrintDistribution = json['flag_print_distribution'] as bool?
  ..pagesQuantity = (json['pages_quantity'] as num?)?.toInt()
  ..status = json['status'] as String?;

Map<String, dynamic> _$FineModelToJson(FineModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'reason': instance.reason,
      'occurrence_date': instance.occurrenceDate?.toIso8601String(),
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'flag_email_distribution': instance.flagEmailDistribution,
      'flag_print_distribution': instance.flagPrintDistribution,
      'pages_quantity': instance.pagesQuantity,
      'status': instance.status,
    };
