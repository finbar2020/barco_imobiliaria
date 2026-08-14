// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementDetailModel _$AnnouncementDetailModelFromJson(
        Map<String, dynamic> json) =>
    AnnouncementDetailModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
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
      ..status = json['status'] as String?
      ..recipientList = json['recipient_list'] as String?;

Map<String, dynamic> _$AnnouncementDetailModelToJson(
        AnnouncementDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'occurrence_date': instance.occurrenceDate?.toIso8601String(),
      'content': instance.content,
      'created_at': instance.createdAt?.toIso8601String(),
      'flag_email_distribution': instance.flagEmailDistribution,
      'flag_print_distribution': instance.flagPrintDistribution,
      'pages_quantity': instance.pagesQuantity,
      'status': instance.status,
      'recipient_list': instance.recipientList,
    };
