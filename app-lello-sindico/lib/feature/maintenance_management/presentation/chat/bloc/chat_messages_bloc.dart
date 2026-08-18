import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/chat/get_chat_messages_use_case.dart';
import '../../../domain/use_cases/chat/send_chat_message_use_case.dart';
import '../../../domain/repository/chat_repository.dart';
import '../../../domain/entity/chat/chat_message_entity.dart';
import 'chat_messages_event.dart';
import 'chat_messages_state.dart';

/// BLoC para gerenciar mensagens de um canal de chat
class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final GetChatMessagesUseCase _getMessagesUseCase;
  final SendChatMessageUseCase _sendMessageUseCase;
  final ChatRepository _chatRepository;
  
  StreamSubscription<ChatMessageEntity>? _messagesSubscription;
  String? _currentChannelId;

  ChatMessagesBloc(
    this._getMessagesUseCase,
    this._sendMessageUseCase,
    this._chatRepository,
  ) : super(const ChatMessagesInitialState()) {
    on<LoadChatMessagesEvent>(_onLoadMessages);
    on<SendChatMessageEvent>(_onSendMessage);
    on<NewMessageReceivedInChannelEvent>(_onNewMessageReceived);
    on<RefreshChatMessagesEvent>(_onRefreshMessages);
    on<RetrySendMessageEvent>(_onRetrySendMessage);
    
    // Escutar mensagens em tempo real
    _listenToMessages();
  }

  Future<void> _onLoadMessages(
    LoadChatMessagesEvent event,
    Emitter<ChatMessagesState> emit,
  ) async {
    emit(const ChatMessagesLoadingState());
    _currentChannelId = event.channelId;

    final result = await _getMessagesUseCase(
      GetChatMessagesRequest(
        channelId: event.channelId,
        before: event.before,
        after: event.after,
        limit: event.limit ?? 50,
      ),
    );

    result.fold(
      (failure) {
        emit(ChatMessagesErrorState(failure.toString()));
      },
      (response) {
        if (response.messages.isEmpty) {
          emit(ChatMessagesEmptyState(currentUserId: response.currentUserId));
        } else {
          emit(ChatMessagesLoadedState(
            response.messages,
            currentUserId: response.currentUserId,
          ));
        }
      },
    );
  }

  Future<void> _onSendMessage(
    SendChatMessageEvent event,
    Emitter<ChatMessagesState> emit,
  ) async {
    final currentState = state;
    final messages = currentState is ChatMessagesLoadedState
        ? currentState.messages
        : <ChatMessageEntity>[];

    final currentUserId = currentState is ChatMessagesLoadedState
        ? currentState.currentUserId
        : (currentState is ChatMessagesEmptyState
            ? currentState.currentUserId
            : null);

    // Criar mensagem temporária para feedback imediato
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    print('📤 Criando mensagem temporária: $tempId');
    
    final tempMessage = ChatMessageEntity(
      id: tempId,
      content: event.content,
      createdAt: DateTime.now(),
      authorId: currentUserId ?? '',
      channelId: event.channelId,
      messageType: 'text',
      author: ChatAuthorEntity(
        id: currentUserId ?? '',
        name: 'Você',
        email: '',
      ),
      isSending: true,
      isFailed: false,
    );

    // Adicionar mensagem temporária imediatamente
    final messagesWithTemp = [...messages, tempMessage];
    emit(ChatMessagesLoadedState(
      messagesWithTemp,
      currentUserId: currentUserId,
    ));

    // Enviar mensagem via API em background
    final result = await _sendMessageUseCase(
      SendChatMessageRequest(
        channelId: event.channelId,
        content: event.content,
        attachmentId: event.attachmentId,
      ),
    );

    result.fold(
      (failure) {
        print('❌ Erro ao enviar mensagem: $failure');
        // Marcar mensagem como falha
        final currentMessages = (state as ChatMessagesLoadedState).messages;
        final updatedMessages = currentMessages.map((m) {
          if (m.id == tempId) {
            return m.copyWith(isSending: false, isFailed: true);
          }
          return m;
        }).toList();
        
        emit(ChatMessagesLoadedState(
          updatedMessages,
          currentUserId: currentUserId,
        ));
      },
      (sentMessage) {
        print('✅ Mensagem enviada via API: ${sentMessage.id}');
        // WebSocket vai receber e substituir automaticamente
      },
    );
  }

  void _onNewMessageReceived(
    NewMessageReceivedInChannelEvent event,
    Emitter<ChatMessagesState> emit,
  ) {
    print('📬 BLoC recebeu mensagem do stream: ${event.message.id}');
    
    // Só processar se for do canal atual
    if (event.message.channelId != _currentChannelId) {
      print('⚠️ Mensagem ignorada - canal diferente');
      return;
    }

    final currentState = state;
    
    if (currentState is ChatMessagesLoadedState) {
      // Verificar se a mensagem já existe (não temporária)
      final exists = currentState.messages.any((m) => 
        m.id == event.message.id && !m.id.startsWith('temp_')
      );
      if (exists) {
        print('⚠️ Mensagem duplicada ignorada: ${event.message.id}');
        return;
      }
      
      print('✅ Adicionando nova mensagem: ${event.message.id}');
      
      // Remover mensagens temporárias com o mesmo conteúdo
      // (a mensagem real do WebSocket substitui a temporária)
      final messagesWithoutTemp = currentState.messages.where((m) {
        if (m.id.startsWith('temp_') && m.content == event.message.content) {
          print('🗑️ Removendo mensagem temporária: ${m.id}');
          return false;
        }
        return true;
      }).toList();
      
      final updatedMessages = [...messagesWithoutTemp, event.message];
      emit(ChatMessagesLoadedState(
        updatedMessages,
        currentUserId: currentState.currentUserId,
      ));
    }
  }

  Future<void> _onRefreshMessages(
    RefreshChatMessagesEvent event,
    Emitter<ChatMessagesState> emit,
  ) async {
    add(LoadChatMessagesEvent(channelId: event.channelId));
  }

  Future<void> _onRetrySendMessage(
    RetrySendMessageEvent event,
    Emitter<ChatMessagesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatMessagesLoadedState) return;

    final messages = currentState.messages;
    final currentUserId = currentState.currentUserId;

    // Encontrar mensagem com falha
    final failedMessage = messages.firstWhere(
      (m) => m.id == event.messageId,
      orElse: () => throw Exception('Mensagem não encontrada'),
    );

    // Marcar como enviando novamente
    final retryingMessage = failedMessage.copyWith(
      isSending: true,
      isFailed: false,
    );

    // Atualizar UI imediatamente
    final updatedMessages = messages.map((m) {
      return m.id == event.messageId ? retryingMessage : m;
    }).toList();

    emit(ChatMessagesLoadedState(
      updatedMessages,
      currentUserId: currentUserId,
    ));

    // Tentar enviar novamente
    final result = await _sendMessageUseCase(
      SendChatMessageRequest(
        channelId: event.channelId,
        content: event.content,
        attachmentId: event.attachmentId,
      ),
    );

    result.fold(
      (failure) {
        // Falhou novamente, marcar como erro
        final failedAgain = retryingMessage.copyWith(
          isSending: false,
          isFailed: true,
        );

        final messagesWithError = messages.map((m) {
          return m.id == event.messageId ? failedAgain : m;
        }).toList();

        emit(ChatMessagesLoadedState(
          messagesWithError,
          currentUserId: currentUserId,
        ));
      },
      (sentMessage) {
        // Sucesso! Substituir pela mensagem real
        final messagesWithSent = messages.map((m) {
          return m.id == event.messageId ? sentMessage : m;
        }).toList();

        emit(ChatMessagesLoadedState(
          messagesWithSent,
          currentUserId: currentUserId,
        ));
      },
    );
  }

  void _listenToMessages() {
    _messagesSubscription = _chatRepository.messagesStream.listen(
      (message) {
        print('📬 BLoC recebeu mensagem do stream: ${message.id}');
        add(NewMessageReceivedInChannelEvent(message));
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
