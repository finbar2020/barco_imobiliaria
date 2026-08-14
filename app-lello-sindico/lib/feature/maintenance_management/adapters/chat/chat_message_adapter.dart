import 'package:intl/intl.dart';
import '../../data/model/chat/chat_message_model.dart';
import '../../domain/entity/chat/chat_message_entity.dart';

/// Extension para converter ChatMessageModel → ChatMessageEntity
extension ChatMessageModelAdapter on ChatMessageModel {
  DateTime _parseDate(String dateStr) {
    try {
      // Tentar formato brasileiro: dd/MM/yyyy HH:mm:ss
      final brazilianFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
      return brazilianFormat.parse(dateStr);
    } catch (e) {
      // Fallback para ISO 8601
      return DateTime.parse(dateStr);
    }
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      content: content,
      channelId: channelId ?? '',
      authorId: authorId ?? author.id,
      messageType: messageType ?? 'TEXT',
      createdAt: _parseDate(createdAt),
      author: author.toEntity(),
      attachment: attachment != null ? attachment!.toEntity() : null,
      isUnread: false,
      isSending: false,
      isFailed: false,
    );
  }
}

/// Extension para converter List<ChatMessageModel> → List<ChatMessageEntity>
extension ChatMessageListAdapter on List<ChatMessageModel> {
  List<ChatMessageEntity> toEntityList() {
    return map((model) => model.toEntity()).toList();
  }
}

/// Extension para converter ChatAuthorModel → ChatAuthorEntity
extension ChatAuthorModelAdapter on ChatAuthorModel {
  ChatAuthorEntity toEntity() {
    return ChatAuthorEntity(
      id: id,
      name: name,
      email: email,
      imageUrl: imageUrl,
      username: username,
      status: status,
      profile: profile != null ? profile!.toEntity() : null,
    );
  }
}

/// Extension para converter ChatAuthorProfileModel → ChatAuthorProfileEntity
extension ChatAuthorProfileModelAdapter on ChatAuthorProfileModel {
  ChatAuthorProfileEntity toEntity() {
    return ChatAuthorProfileEntity(
      id: id,
      name: name,
      description: description,
    );
  }
}

/// Extension para converter ChatAttachmentModel → ChatAttachmentEntity
extension ChatAttachmentModelAdapter on ChatAttachmentModel {
  ChatAttachmentEntity toEntity() {
    return ChatAttachmentEntity(
      id: id,
      name: name,
      url: url,
      attachmentType: attachmentType,
      fileSize: fileSize,
    );
  }
}
