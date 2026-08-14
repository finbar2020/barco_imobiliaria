import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

/// Model de mensagem do chat
@JsonSerializable()
class ChatMessageModel {
  final String id;
  final String? content;
  @JsonKey(name: 'channel_id')
  final String? channelId;
  @JsonKey(name: 'author_id')
  final String? authorId;
  @JsonKey(
      name: 'messageType') // ✅ Corrigido: API usa camelCase, não snake_case
  final String? messageType;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  final ChatAuthorModel author;
  final ChatAttachmentModel? attachment;

  const ChatMessageModel({
    required this.id,
    this.content,
    this.channelId,
    this.authorId,
    this.messageType,
    required this.createdAt,
    required this.author,
    this.attachment,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}

/// Model de autor da mensagem
@JsonSerializable()
class ChatAuthorModel {
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  final String? username;
  final String? status;
  final ChatAuthorProfileModel? profile;

  const ChatAuthorModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.username,
    this.status,
    this.profile,
  });

  factory ChatAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$ChatAuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAuthorModelToJson(this);
}

/// Model de perfil do autor
@JsonSerializable()
class ChatAuthorProfileModel {
  final String id;
  final String name;
  final String? description;

  const ChatAuthorProfileModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory ChatAuthorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ChatAuthorProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAuthorProfileModelToJson(this);
}

/// Model de anexo da mensagem
@JsonSerializable()
class ChatAttachmentModel {
  final String id;
  final String name;
  final String url;
  @JsonKey(name: 'attachableId')
  final String? attachableId;
  @JsonKey(name: 'attachableType')
  final String? attachableType;
  @JsonKey(name: 'attachmentType')
  final String? attachmentType;
  @JsonKey(name: 'fileSize')
  final String? fileSize;
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  const ChatAttachmentModel({
    required this.id,
    required this.name,
    required this.url,
    this.attachableId,
    this.attachableType,
    this.attachmentType,
    this.fileSize,
    this.createdAt,
  });

  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$ChatAttachmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAttachmentModelToJson(this);
}

/// Cursor de paginação
@JsonSerializable()
class MessageCursorModel {
  final String? startCursor;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const MessageCursorModel({
    this.startCursor,
    this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory MessageCursorModel.fromJson(Map<String, dynamic> json) =>
      _$MessageCursorModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageCursorModelToJson(this);
}

/// Response de lista de mensagens
@JsonSerializable()
class ChatMessagesResponseModel {
  final bool success;
  final List<ChatMessageModel> data;
  final MessageCursorModel cursor;
  final String? currentUserId;

  const ChatMessagesResponseModel({
    required this.success,
    required this.data,
    required this.cursor,
    this.currentUserId,
  });

  factory ChatMessagesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessagesResponseModelToJson(this);
}
