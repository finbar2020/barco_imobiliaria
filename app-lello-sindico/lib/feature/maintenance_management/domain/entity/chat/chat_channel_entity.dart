import 'package:equatable/equatable.dart';

/// PageInfo para paginação cursor-based
class PageInfoEntity extends Equatable {
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  const PageInfoEntity({
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });

  @override
  List<Object?> get props => [hasNextPage, hasPreviousPage, startCursor, endCursor];
}

/// Task info dentro do canal
class ChannelTaskEntity extends Equatable {
  final String id;
  final String name;

  const ChannelTaskEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

/// Author da última mensagem
class MessageAuthorEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const MessageAuthorEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [id, name, email];
}

/// Última mensagem do canal
class ChannelLastMessageEntity extends Equatable {
  final String id;
  final String? content;
  final DateTime createdAt;
  final MessageAuthorEntity author;

  const ChannelLastMessageEntity({
    required this.id,
    this.content,
    required this.createdAt,
    required this.author,
  });

  ChannelLastMessageEntity copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    MessageAuthorEntity? author,
  }) {
    return ChannelLastMessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
    );
  }

  @override
  List<Object?> get props => [id, content, createdAt, author];
}

/// Entidade de canal de chat
class ChatChannelEntity extends Equatable {
  final String id;
  final String typeTask;
  final String status;
  final ChannelTaskEntity task;
  final ChannelLastMessageEntity? lastMessage;
  final bool hasUnreadMessages;

  const ChatChannelEntity({
    required this.id,
    required this.typeTask,
    required this.status,
    required this.task,
    this.lastMessage,
    this.hasUnreadMessages = false,
  });

  ChatChannelEntity copyWith({
    String? id,
    String? typeTask,
    String? status,
    ChannelTaskEntity? task,
    ChannelLastMessageEntity? lastMessage,
    bool? hasUnreadMessages,
  }) {
    return ChatChannelEntity(
      id: id ?? this.id,
      typeTask: typeTask ?? this.typeTask,
      status: status ?? this.status,
      task: task ?? this.task,
      lastMessage: lastMessage ?? this.lastMessage,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
    );
  }

  bool get isDone => status == 'DONE';
  bool get hasUnread => lastMessage != null;

  @override
  List<Object?> get props => [
        id,
        typeTask,
        status,
        task,
        lastMessage,
        hasUnreadMessages,
      ];
}

/// Response de lista de canais com paginação
class ChatChannelsResponseEntity extends Equatable {
  final List<ChatChannelEntity> channels;
  final PageInfoEntity? pageInfo;
  final String? ttJwtToken;

  const ChatChannelsResponseEntity({
    required this.channels,
    this.pageInfo,
    this.ttJwtToken,
  });

  @override
  List<Object?> get props => [channels, pageInfo, ttJwtToken];
}
