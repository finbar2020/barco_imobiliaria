// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      title: json['title'] as String?,
      message: json['message'] as String?,
      visualizedAt: json['visualized_at'] == null
          ? null
          : DateTime.parse(json['visualized_at'] as String),
      status: json['status'] as String?,
      reference: json['reference'] as String?,
      identifier: json['identifier'] as String?,
      module: json['module'] as String?,
      type: json['type'] as String?,
      markRead: json['mark_read'] as bool?,
      inApp: json['in_app'] as bool?,
      typeRedirect: json['type_redirect'] as String?,
      redirectPath: json['redirect_path'] as String?,
      redirectId: json['redirect_id'] as String?,
      callback: json['callback'] as String?,
      hash: json['hash'] as String?,
      bigMessage: json['big_message'] as String?,
      senderId: json['sender_id'] as String?,
      uuidGroup: json['uuid_group'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'title': instance.title,
      'message': instance.message,
      'visualized_at': instance.visualizedAt?.toIso8601String(),
      'status': instance.status,
      'reference': instance.reference,
      'identifier': instance.identifier,
      'module': instance.module,
      'type': instance.type,
      'mark_read': instance.markRead,
      'in_app': instance.inApp,
      'type_redirect': instance.typeRedirect,
      'redirect_path': instance.redirectPath,
      'redirect_id': instance.redirectId,
      'callback': instance.callback,
      'hash': instance.hash,
      'big_message': instance.bigMessage,
      'sender_id': instance.senderId,
      'uuid_group': instance.uuidGroup,
    };
