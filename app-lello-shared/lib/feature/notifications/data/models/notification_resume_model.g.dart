// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResumeModel _$NotificationResumeModelFromJson(
        Map<String, dynamic> json) =>
    NotificationResumeModel(
      totalRead: (json['total_read'] as num?)?.toInt(),
      totalIgnored: (json['total_ignored'] as num?)?.toInt(),
      totalExcluded: (json['total_excluded'] as num?)?.toInt(),
      totalReceived: (json['total_received'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NotificationResumeModelToJson(
        NotificationResumeModel instance) =>
    <String, dynamic>{
      'total_read': instance.totalRead,
      'total_ignored': instance.totalIgnored,
      'total_excluded': instance.totalExcluded,
      'total_received': instance.totalReceived,
    };
