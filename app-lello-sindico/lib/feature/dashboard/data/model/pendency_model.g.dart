// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pendency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendencyModel _$PendencyModelFromJson(Map<String, dynamic> json) =>
    PendencyModel(
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
      iconType: json['icon_type'] as String?,
      identifier: json['identifier'] as String?,
      idSender: json['id_sender'] as String?,
      type: json['type'] as String?,
      read: json['read'] as bool?,
    );

Map<String, dynamic> _$PendencyModelToJson(PendencyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'title': instance.title,
      'message': instance.message,
      'visualized_at': instance.visualizedAt?.toIso8601String(),
      'status': instance.status,
      'reference': instance.reference,
      'icon_type': instance.iconType,
      'identifier': instance.identifier,
      'id_sender': instance.idSender,
      'type': instance.type,
      'read': instance.read,
    };
