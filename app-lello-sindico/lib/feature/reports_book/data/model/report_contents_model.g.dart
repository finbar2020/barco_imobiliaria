// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_contents_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportContentsModel _$ReportContentsModelFromJson(Map<String, dynamic> json) =>
    ReportContentsModel(
      id: json['id'] as String?,
      numReport: (json['num_report'] as num?)?.toInt(),
      typeUser: (json['type_user'] as num?)?.toInt(),
      userName: json['user_name'] as String?,
      content: json['content'] as String?,
      attachment: json['attachment'] as String?,
      attachmentType: json['attachment_type'] as String?,
      dateContent: json['date_content'] == null
          ? null
          : DateTime.parse(json['date_content'] as String),
    );

Map<String, dynamic> _$ReportContentsModelToJson(
        ReportContentsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'num_report': instance.numReport,
      'type_user': instance.typeUser,
      'user_name': instance.userName,
      'content': instance.content,
      'attachment': instance.attachment,
      'attachment_type': instance.attachmentType,
      'date_content': instance.dateContent?.toIso8601String(),
    };
