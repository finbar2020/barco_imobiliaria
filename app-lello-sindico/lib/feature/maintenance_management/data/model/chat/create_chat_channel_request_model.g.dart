// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_chat_channel_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChatChannelRequestModel _$CreateChatChannelRequestModelFromJson(
        Map<String, dynamic> json) =>
    CreateChatChannelRequestModel(
      taskId: json['taskId'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CreateChatChannelRequestModelToJson(
        CreateChatChannelRequestModel instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      if (instance.name case final value?) 'name': value,
    };

CreateChatChannelResponseModel _$CreateChatChannelResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreateChatChannelResponseModel(
      channelId: json['channelId'] as String,
    );

Map<String, dynamic> _$CreateChatChannelResponseModelToJson(
        CreateChatChannelResponseModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
    };
