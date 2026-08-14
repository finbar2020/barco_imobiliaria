// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghost_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GhostNotificationModel _$GhostNotificationModelFromJson(
        Map<String, dynamic> json) =>
    GhostNotificationModel(
      id: json['id'] as String?,
      token: json['token'] as String?,
      appType: json['app_type'] as String?,
      recivedDate: json['recived_date'] as String?,
      appVersion: json['app_version'] as String?,
      deviceName: json['device_name'] as String?,
      logedUserCpf: json['loged_user_cpf'] as String?,
      logedUserId: json['loged_user_id'] as String?,
      customData: json['custom_data'],
      type: json['type'] as String?,
    );

Map<String, dynamic> _$GhostNotificationModelToJson(
        GhostNotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'app_type': instance.appType,
      'recived_date': instance.recivedDate,
      'app_version': instance.appVersion,
      'device_name': instance.deviceName,
      'loged_user_cpf': instance.logedUserCpf,
      'loged_user_id': instance.logedUserId,
      'custom_data': instance.customData,
      'type': instance.type,
    };
