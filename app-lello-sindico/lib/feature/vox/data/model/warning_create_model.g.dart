// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warning_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarningCreateModel _$WarningCreateModelFromJson(Map<String, dynamic> json) =>
    WarningCreateModel()
      ..content = json['content'] as String?
      ..createdAt = json['created_at'] as String?
      ..description = json['description'] as String?
      ..flagEmailBodyAttachment = json['flag_email_body_attachment'] as bool?
      ..flagEmailDistribution = json['flag_email_distribution'] as bool?
      ..flagPrintDistribution = json['flag_print_distribution'] as bool?
      ..id = json['id'] as String?
      ..modelId = json['model_id'] as String?
      ..name = json['name'] as String?
      ..occurrenceDate = json['occurrence_date'] == null
          ? null
          : DateTime.parse(json['occurrence_date'] as String)
      ..pagesQuantity = (json['pages_quantity'] as num?)?.toInt()
      ..reason = json['reason'] as String?
      ..reasonId = json['reason_id'] as String?
      ..recipientList = (json['recipient_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..recipientType = (json['recipient_type'] as num?)?.toInt()
      ..singleCopiesQuantity = (json['single_copies_quantity'] as num?)?.toInt()
      ..status = json['status'] as String?
      ..unityId = json['unity_id'] as String?;

Map<String, dynamic> _$WarningCreateModelToJson(WarningCreateModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'created_at': instance.createdAt,
      'description': instance.description,
      'flag_email_body_attachment': instance.flagEmailBodyAttachment,
      'flag_email_distribution': instance.flagEmailDistribution,
      'flag_print_distribution': instance.flagPrintDistribution,
      'id': instance.id,
      'model_id': instance.modelId,
      'name': instance.name,
      'occurrence_date': instance.occurrenceDate?.toIso8601String(),
      'pages_quantity': instance.pagesQuantity,
      'reason': instance.reason,
      'reason_id': instance.reasonId,
      'recipient_list': instance.recipientList,
      'recipient_type': instance.recipientType,
      'single_copies_quantity': instance.singleCopiesQuantity,
      'status': instance.status,
      'unity_id': instance.unityId,
    };
