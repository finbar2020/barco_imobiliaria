// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warning_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarningRequestModel _$WarningRequestModelFromJson(Map<String, dynamic> json) =>
    WarningRequestModel(
      serviceId: json['service_id'] as String? ?? "790850",
      recipientList: (json['recipient_list'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : DocumentAttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..id = json['id'] as String?
      ..condominiumId = json['condominium_id'] as String?
      ..unityId = json['unity_id'] as String?
      ..content = json['content'] as String?
      ..block = json['block'] as String?
      ..reason = json['reason'] as String?
      ..model = json['model'] as String?
      ..flagEmailDistribution = json['flag_email_distribution'] as bool?
      ..occurrenceDate = json['occurrence_date'] == null
          ? null
          : DateTime.parse(json['occurrence_date'] as String)
      ..flagPrintDistribution = json['flag_print_distribution'] as bool?
      ..flagOverride = json['flag_overrride'] as bool?
      ..recipientType = (json['recipient_type'] as num?)?.toInt()
      ..flagEmailBodyAttachment = json['flag_email_body_attachment'] as bool?
      ..singleCopiesQuantity = (json['single_copies_quantity'] as num?)?.toInt()
      ..userId = json['user_id'] as String?;

Map<String, dynamic> _$WarningRequestModelToJson(
        WarningRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'condominium_id': instance.condominiumId,
      'unity_id': instance.unityId,
      'content': instance.content,
      'block': instance.block,
      'reason': instance.reason,
      'model': instance.model,
      'recipient_list': instance.recipientList,
      'flag_email_distribution': instance.flagEmailDistribution,
      'occurrence_date': instance.occurrenceDate?.toIso8601String(),
      'flag_print_distribution': instance.flagPrintDistribution,
      'flag_overrride': instance.flagOverride,
      'recipient_type': instance.recipientType,
      'flag_email_body_attachment': instance.flagEmailBodyAttachment,
      'single_copies_quantity': instance.singleCopiesQuantity,
      'user_id': instance.userId,
      'attachments': instance.attachments,
    };
