// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fine_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FineRequestModel _$FineRequestModelFromJson(Map<String, dynamic> json) =>
    FineRequestModel(
      serviceId: json['service_id'] as String? ?? "790851",
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
      ..userId = json['user_id'] as String?
      ..condominiumId = json['condominium_id'] as String?
      ..unityId = json['unity_id'] as String?
      ..content = json['content'] as String?
      ..block = json['block'] as String?
      ..flagEmailDistribution = json['flag_email_distribution'] as bool?
      ..flagPrintDistribution = json['flag_print_distribution'] as bool?
      ..flagOverride = json['flag_overrride'] as bool?
      ..recipientType = (json['recipient_type'] as num?)?.toInt()
      ..flagEmailBodyAttachment = json['flag_email_body_attachment'] as bool?
      ..singleCopiesQuantity = (json['single_copies_quantity'] as num?)?.toInt()
      ..value = json['value'] as String?
      ..occurrenceDate = json['occurrence_date'] == null
          ? null
          : DateTime.parse(json['occurrence_date'] as String);

Map<String, dynamic> _$FineRequestModelToJson(FineRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'service_id': instance.serviceId,
      'condominium_id': instance.condominiumId,
      'unity_id': instance.unityId,
      'content': instance.content,
      'block': instance.block,
      'recipient_list': instance.recipientList,
      'flag_email_distribution': instance.flagEmailDistribution,
      'flag_print_distribution': instance.flagPrintDistribution,
      'flag_overrride': instance.flagOverride,
      'recipient_type': instance.recipientType,
      'flag_email_body_attachment': instance.flagEmailBodyAttachment,
      'single_copies_quantity': instance.singleCopiesQuantity,
      'attachments': instance.attachments,
      'value': instance.value,
      'occurrence_date': instance.occurrenceDate?.toIso8601String(),
    };
