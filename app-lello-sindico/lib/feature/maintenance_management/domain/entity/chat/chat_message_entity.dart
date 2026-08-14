import 'package:equatable/equatable.dart';

/// Entidade de mensagem do chat de manutenção
class ChatMessageEntity extends Equatable {
  final String id;
  final String? content;
  final String channelId;
  final String authorId;
  final String messageType;
  final DateTime createdAt;
  final ChatAuthorEntity author;
  final ChatAttachmentEntity? attachment;
  final bool isUnread;
  final bool isSending;
  final bool isFailed;

  const ChatMessageEntity({
    required this.id,
    this.content,
    required this.channelId,
    required this.authorId,
    required this.messageType,
    required this.createdAt,
    required this.author,
    this.attachment,
    this.isUnread = false,
    this.isSending = false,
    this.isFailed = false,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? content,
    String? channelId,
    String? authorId,
    String? messageType,
    DateTime? createdAt,
    ChatAuthorEntity? author,
    ChatAttachmentEntity? attachment,
    bool? isUnread,
    bool? isSending,
    bool? isFailed,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      channelId: channelId ?? this.channelId,
      authorId: authorId ?? this.authorId,
      messageType: messageType ?? this.messageType,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      attachment: attachment ?? this.attachment,
      isUnread: isUnread ?? this.isUnread,
      isSending: isSending ?? this.isSending,
      isFailed: isFailed ?? this.isFailed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        channelId,
        authorId,
        messageType,
        createdAt,
        author,
        attachment,
        isUnread,
        isSending,
        isFailed,
      ];
}

/// Entidade de autor da mensagem
class ChatAuthorEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? username;
  final String? status;
  final ChatAuthorProfileEntity? profile;

  const ChatAuthorEntity({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.username,
    this.status,
    this.profile,
  });

  @override
  List<Object?> get props => [id, name, email, imageUrl, username, status, profile];
}

/// Entidade de perfil do autor
class ChatAuthorProfileEntity extends Equatable {
  final String id;
  final String name;
  final String? description;

  const ChatAuthorProfileEntity({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}

/// Entidade de anexo da mensagem
class ChatAttachmentEntity extends Equatable {
  final String id;
  final String name;
  final String url;
  final String? attachmentType;
  final String? fileSize;

  const ChatAttachmentEntity({
    required this.id,
    required this.name,
    required this.url,
    this.attachmentType,
    this.fileSize,
  });

  @override
  List<Object?> get props => [id, name, url, attachmentType, fileSize];
}
