// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsPreferencesModel _$NotificationsPreferencesModelFromJson(
        Map<String, dynamic> json) =>
    NotificationsPreferencesModel(
      id_pendency_rule_reference: json['id_pendency_rule_reference'] as String?,
      id_pendency_rule: json['id_pendency_rule'] as String?,
      reference: (json['reference'] as num).toInt(),
      quarantine_days: (json['quarantine_days'] as num?)?.toInt(),
      last_execution: json['last_execution'] as String?,
      active: json['active'] as bool,
      module: json['module'] as String,
      config_type: json['config_type'] as String,
      alt_text: json['alt_text'] as String,
      receive_type: (json['receive_type'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NotificationsPreferencesModelToJson(
        NotificationsPreferencesModel instance) =>
    <String, dynamic>{
      'id_pendency_rule_reference': instance.id_pendency_rule_reference,
      'id_pendency_rule': instance.id_pendency_rule,
      'reference': instance.reference,
      'quarantine_days': instance.quarantine_days,
      'last_execution': instance.last_execution,
      'active': instance.active,
      'module': instance.module,
      'config_type': instance.config_type,
      'alt_text': instance.alt_text,
      'receive_type': instance.receive_type,
    };
