// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ia_bella_send_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IaBellaSendMessageModel _$IaBellaSendMessageModelFromJson(
        Map<String, dynamic> json) =>
    IaBellaSendMessageModel(
      question: json['question'] as String?,
      uuidSession: json['uuid_session'] as String?,
    );

Map<String, dynamic> _$IaBellaSendMessageModelToJson(
        IaBellaSendMessageModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'uuid_session': instance.uuidSession,
    };
