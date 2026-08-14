import 'package:json_annotation/json_annotation.dart';

part 'chat_channel_model.g.dart';

/// Task info dentro do canal
@JsonSerializable()
class ChannelTaskModel {
  final String id;
  final String name;

  const ChannelTaskModel({
    required this.id,
    required this.name,
  });

  factory ChannelTaskModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelTaskModelToJson(this);
}

/// Author da última mensagem
@JsonSerializable()
class MessageAuthorModel {
  final String id;
  final String name;
  final String email;

  const MessageAuthorModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory MessageAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$MessageAuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageAuthorModelToJson(this);
}

/// Última mensagem do canal
@JsonSerializable()
class ChannelLastMessageModel {
  final String id;
  final String? content;
  final String createdAt;
  final MessageAuthorModel author;

  const ChannelLastMessageModel({
    required this.id,
    this.content,
    required this.createdAt,
    required this.author,
  });

  factory ChannelLastMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelLastMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelLastMessageModelToJson(this);
}

/// Model de canal de chat
@JsonSerializable()
class ChatChannelModel {
  final String id;
  final String typeTask;
  final String status;
  final ChannelTaskModel task;
  final ChannelLastMessageModel? lastMessage;

  const ChatChannelModel({
    required this.id,
    required this.typeTask,
    required this.status,
    required this.task,
    this.lastMessage,
  });

  factory ChatChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChatChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatChannelModelToJson(this);
}

/// PageInfo para paginação cursor-based
@JsonSerializable()
class PageInfoModel {
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  const PageInfoModel({
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });

  factory PageInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PageInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageInfoModelToJson(this);
}

/// Response de lista de canais com paginação
@JsonSerializable()
class ChatChannelsResponseModel {
  final bool success;
  final List<ChatChannelModel> data;
  final PageInfoModel? pageInfo;
  @JsonKey(name: 'ttJwtToken')
  final String? ttJwtToken;

  const ChatChannelsResponseModel({
    required this.success,
    required this.data,
    this.pageInfo,
    this.ttJwtToken,
  });

  factory ChatChannelsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChatChannelsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatChannelsResponseModelToJson(this);
}
