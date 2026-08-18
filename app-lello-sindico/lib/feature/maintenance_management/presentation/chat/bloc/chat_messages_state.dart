import '../../../domain/entity/chat/chat_message_entity.dart';

/// Estados do BLoC de mensagens de chat
abstract class ChatMessagesState {
  const ChatMessagesState();
}

/// Estado inicial
class ChatMessagesInitialState extends ChatMessagesState {
  const ChatMessagesInitialState();
}

/// Estado de carregamento
class ChatMessagesLoadingState extends ChatMessagesState {
  const ChatMessagesLoadingState();
}

/// Estado com mensagens carregadas
class ChatMessagesLoadedState extends ChatMessagesState {
  final List<ChatMessageEntity> messages;
  final String? currentUserId;

  const ChatMessagesLoadedState(this.messages, {this.currentUserId});
}

/// Estado vazio (sem mensagens)
class ChatMessagesEmptyState extends ChatMessagesState {
  final String? currentUserId;
  
  const ChatMessagesEmptyState({this.currentUserId});
}

/// Estado de erro
class ChatMessagesErrorState extends ChatMessagesState {
  final String message;

  const ChatMessagesErrorState(this.message);
}

/// Estado de envio de mensagem
class ChatMessageSendingState extends ChatMessagesState {
  final List<ChatMessageEntity> messages;
  final ChatMessageEntity sendingMessage;

  const ChatMessageSendingState(this.messages, this.sendingMessage);
}
