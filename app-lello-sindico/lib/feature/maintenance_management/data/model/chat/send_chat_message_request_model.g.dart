// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chat_message_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendChatMessageRequestModel _$SendChatMessageRequestModelFromJson(
        Map<String, dynamic> json) =>
    SendChatMessageRequestModel(
      channelId: json['channelId'] as String,
      content: json['content'] as String,
      messageType: json['messageType'] as String? ?? 'TEXT',
      sentAt: json['sentAt'] as String,
    );

Map<String, dynamic> _$SendChatMessageRequestModelToJson(
        SendChatMessageRequestModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'content': instance.content,
      'messageType': instance.messageType,
      'sentAt': instance.sentAt,
    };
