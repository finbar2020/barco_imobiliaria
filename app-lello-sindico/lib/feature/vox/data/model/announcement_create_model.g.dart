// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementCreateModel _$AnnouncementCreateModelFromJson(
        Map<String, dynamic> json) =>
    AnnouncementCreateModel(
      recipientList: (json['recipient_list'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    )
      ..templateId = json['template_id'] as String?
      ..modelId = json['model_id'] as String?
      ..title = json['title'] as String?
      ..content = json['content'] as String?
      ..contentHtml = json['content_html'] as String?
      ..flagEmailDistribution = json['flag_email_distribution'] as bool?
      ..flagPrintDistribution = json['flag_print_distribution'] as bool?
      ..flagOverride = json['flag_overrride'] as bool?
      ..recipientType = (json['recipient_type'] as num?)?.toInt()
      ..flagEmailBodyAttachment = json['flag_email_body_attachment'] as bool?
      ..singleCopiesQuantity = json['single_copies_quantity'] as String?;

Map<String, dynamic> _$AnnouncementCreateModelToJson(
        AnnouncementCreateModel instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'model_id': instance.modelId,
      'title': instance.title,
      'content': instance.content,
      if (instance.contentHtml case final value?) 'content_html': value,
      'flag_email_distribution': instance.flagEmailDistribution,
      'flag_print_distribution': instance.flagPrintDistribution,
      'flag_overrride': instance.flagOverride,
      'recipient_type': instance.recipientType,
      'recipient_list': instance.recipientList,
      'flag_email_body_attachment': instance.flagEmailBodyAttachment,
      'single_copies_quantity': instance.singleCopiesQuantity,
    };
