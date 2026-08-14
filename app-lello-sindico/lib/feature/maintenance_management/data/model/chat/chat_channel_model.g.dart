// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelTaskModel _$ChannelTaskModelFromJson(Map<String, dynamic> json) =>
    ChannelTaskModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ChannelTaskModelToJson(ChannelTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MessageAuthorModel _$MessageAuthorModelFromJson(Map<String, dynamic> json) =>
    MessageAuthorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$MessageAuthorModelToJson(MessageAuthorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };

ChannelLastMessageModel _$ChannelLastMessageModelFromJson(
        Map<String, dynamic> json) =>
    ChannelLastMessageModel(
      id: json['id'] as String,
      content: json['content'] as String?,
      createdAt: json['createdAt'] as String,
      author:
          MessageAuthorModel.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChannelLastMessageModelToJson(
        ChannelLastMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'author': instance.author,
    };

ChatChannelModel _$ChatChannelModelFromJson(Map<String, dynamic> json) =>
    ChatChannelModel(
      id: json['id'] as String,
      typeTask: json['typeTask'] as String,
      status: json['status'] as String,
      task: ChannelTaskModel.fromJson(json['task'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChannelLastMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatChannelModelToJson(ChatChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeTask': instance.typeTask,
      'status': instance.status,
      'task': instance.task,
      'lastMessage': instance.lastMessage,
    };

PageInfoModel _$PageInfoModelFromJson(Map<String, dynamic> json) =>
    PageInfoModel(
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
      startCursor: json['startCursor'] as String?,
      endCursor: json['endCursor'] as String?,
    );

Map<String, dynamic> _$PageInfoModelToJson(PageInfoModel instance) =>
    <String, dynamic>{
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'startCursor': instance.startCursor,
      'endCursor': instance.endCursor,
    };

ChatChannelsResponseModel _$ChatChannelsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChatChannelsResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChatChannelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageInfo: json['pageInfo'] == null
          ? null
          : PageInfoModel.fromJson(json['pageInfo'] as Map<String, dynamic>),
      ttJwtToken: json['ttJwtToken'] as String?,
    );

Map<String, dynamic> _$ChatChannelsResponseModelToJson(
        ChatChannelsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'pageInfo': instance.pageInfo,
      'ttJwtToken': instance.ttJwtToken,
    };
