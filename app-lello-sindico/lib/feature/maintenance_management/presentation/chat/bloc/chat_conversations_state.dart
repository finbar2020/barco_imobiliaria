import '../../../domain/entity/chat/chat_channel_entity.dart';

/// Estados do BLoC de conversas de chat
abstract class ChatConversationsState {
  const ChatConversationsState();
}

/// Estado inicial
class ChatConversationsInitialState extends ChatConversationsState {
  const ChatConversationsInitialState();
}

/// Estado de carregamento
class ChatConversationsLoadingState extends ChatConversationsState {
  const ChatConversationsLoadingState();
}

/// Estado de carregado com paginação
class ChatConversationsLoadedState extends ChatConversationsState {
  final List<ChatChannelEntity> conversations;
  final PageInfoEntity? pageInfo;
  final String? ttJwtToken;

  const ChatConversationsLoadedState(
    this.conversations, {
    this.pageInfo,
    this.ttJwtToken,
  });
}

/// Estado de erro
class ChatConversationsErrorState extends ChatConversationsState {
  final String message;

  const ChatConversationsErrorState(this.message);
}

/// Estado vazio
class ChatConversationsEmptyState extends ChatConversationsState {
  const ChatConversationsEmptyState();
}
