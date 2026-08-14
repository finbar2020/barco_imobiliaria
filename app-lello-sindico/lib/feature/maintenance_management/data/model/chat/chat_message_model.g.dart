// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String,
      content: json['content'] as String?,
      channelId: json['channel_id'] as String?,
      authorId: json['author_id'] as String?,
      messageType: json['messageType'] as String?,
      createdAt: json['createdAt'] as String,
      author: ChatAuthorModel.fromJson(json['author'] as Map<String, dynamic>),
      attachment: json['attachment'] == null
          ? null
          : ChatAttachmentModel.fromJson(
              json['attachment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'channel_id': instance.channelId,
      'author_id': instance.authorId,
      'messageType': instance.messageType,
      'createdAt': instance.createdAt,
      'author': instance.author,
      'attachment': instance.attachment,
    };

ChatAuthorModel _$ChatAuthorModelFromJson(Map<String, dynamic> json) =>
    ChatAuthorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String?,
      username: json['username'] as String?,
      status: json['status'] as String?,
      profile: json['profile'] == null
          ? null
          : ChatAuthorProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatAuthorModelToJson(ChatAuthorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'username': instance.username,
      'status': instance.status,
      'profile': instance.profile,
    };

ChatAuthorProfileModel _$ChatAuthorProfileModelFromJson(
        Map<String, dynamic> json) =>
    ChatAuthorProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ChatAuthorProfileModelToJson(
        ChatAuthorProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

ChatAttachmentModel _$ChatAttachmentModelFromJson(Map<String, dynamic> json) =>
    ChatAttachmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      attachableId: json['attachableId'] as String?,
      attachableType: json['attachableType'] as String?,
      attachmentType: json['attachmentType'] as String?,
      fileSize: json['fileSize'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ChatAttachmentModelToJson(
        ChatAttachmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'attachableId': instance.attachableId,
      'attachableType': instance.attachableType,
      'attachmentType': instance.attachmentType,
      'fileSize': instance.fileSize,
      'createdAt': instance.createdAt,
    };

MessageCursorModel _$MessageCursorModelFromJson(Map<String, dynamic> json) =>
    MessageCursorModel(
      startCursor: json['startCursor'] as String?,
      endCursor: json['endCursor'] as String?,
      hasPreviousPage: json['hasPreviousPage'] as bool,
      hasNextPage: json['hasNextPage'] as bool,
    );

Map<String, dynamic> _$MessageCursorModelToJson(MessageCursorModel instance) =>
    <String, dynamic>{
      'startCursor': instance.startCursor,
      'endCursor': instance.endCursor,
      'hasPreviousPage': instance.hasPreviousPage,
      'hasNextPage': instance.hasNextPage,
    };

ChatMessagesResponseModel _$ChatMessagesResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChatMessagesResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      cursor:
          MessageCursorModel.fromJson(json['cursor'] as Map<String, dynamic>),
      currentUserId: json['currentUserId'] as String?,
    );

Map<String, dynamic> _$ChatMessagesResponseModelToJson(
        ChatMessagesResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'cursor': instance.cursor,
      'currentUserId': instance.currentUserId,
    };
