import '../../data/model/chat/chat_channel_model.dart';
import '../../domain/entity/chat/chat_channel_entity.dart';

/// Extension para converter ChannelTaskModel → ChannelTaskEntity
extension ChannelTaskModelAdapter on ChannelTaskModel {
  ChannelTaskEntity toEntity() {
    return ChannelTaskEntity(
      id: id,
      name: name,
    );
  }
}

/// Extension para converter MessageAuthorModel → MessageAuthorEntity
extension MessageAuthorModelAdapter on MessageAuthorModel {
  MessageAuthorEntity toEntity() {
    return MessageAuthorEntity(
      id: id,
      name: name,
      email: email,
    );
  }
}

/// Extension para converter ChannelLastMessageModel → ChannelLastMessageEntity
extension ChannelLastMessageModelAdapter on ChannelLastMessageModel {
  ChannelLastMessageEntity toEntity() {
    return ChannelLastMessageEntity(
      id: id,
      content: content,
      createdAt: DateTime.parse(createdAt),
      author: author.toEntity(),
    );
  }
}

/// Extension para converter ChatChannelModel → ChatChannelEntity
extension ChatChannelModelAdapter on ChatChannelModel {
  ChatChannelEntity toEntity() {
    return ChatChannelEntity(
      id: id,
      typeTask: typeTask,
      status: status,
      task: task.toEntity(),
      lastMessage: lastMessage != null ? lastMessage!.toEntity() : null,
    );
  }
}

/// Extension para converter List<ChatChannelModel> → List<ChatChannelEntity>
extension ChatChannelListAdapter on List<ChatChannelModel> {
  List<ChatChannelEntity> toEntityList() {
    return map((model) => model.toEntity()).toList();
  }
}

/// Extension para converter PageInfoModel → PageInfoEntity
extension PageInfoModelAdapter on PageInfoModel? {
  PageInfoEntity? toEntity() {
    if (this == null) return null;

    return PageInfoEntity(
      hasNextPage: this!.hasNextPage,
      hasPreviousPage: this!.hasPreviousPage,
      startCursor: this!.startCursor,
      endCursor: this!.endCursor,
    );
  }
}

/// Extension para converter ChatChannelsResponseModel → ChatChannelsResponseEntity
extension ChatChannelsResponseModelAdapter on ChatChannelsResponseModel {
  ChatChannelsResponseEntity toEntity() {
    return ChatChannelsResponseEntity(
      channels: data.toEntityList(),
      pageInfo: pageInfo.toEntity(),
      ttJwtToken: ttJwtToken,
    );
  }
}
