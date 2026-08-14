import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/chat/get_chat_channels_use_case.dart';
import '../../../domain/use_cases/chat/subscribe_to_channel_use_case.dart';
import '../../../domain/use_cases/chat/unsubscribe_from_channel_use_case.dart';
import '../../../domain/use_cases/get_maintenance_tasks_filter_options_use_case.dart';
import '../../../domain/repository/chat_repository.dart';
import '../../../domain/entity/chat/chat_message_entity.dart';
import '../../../domain/entity/chat/chat_channel_entity.dart';
import '../../../domain/entity/filter_options_entity.dart';
import 'chat_conversations_event.dart';
import 'chat_conversations_state.dart';

/// BLoC para gerenciar conversas de chat
class ChatConversationsBloc
    extends Bloc<ChatConversationsEvent, ChatConversationsState> {
  final GetChatChannelsUseCase _getChatChannelsUseCase;
  final SubscribeToChannelUseCase _subscribeToChannelUseCase;
  final UnsubscribeFromChannelUseCase _unsubscribeFromChannelUseCase;
  final GetMaintenanceTasksFilterOptionsUseCase _getFilterOptionsUseCase;
  final ChatRepository _chatRepository;
  
  FilterOptionsEntity? filterOptions;
  
  StreamSubscription<ChatMessageEntity>? _messagesSubscription;
  final Set<String> _subscribedChannels = {};

  ChatConversationsBloc(
    this._getChatChannelsUseCase,
    this._subscribeToChannelUseCase,
    this._unsubscribeFromChannelUseCase,
    this._getFilterOptionsUseCase,
    this._chatRepository,
  ) : super(const ChatConversationsInitialState()) {
    on<LoadChatConversationsEvent>(_onLoadConversations);
    on<LoadMoreConversationsEvent>(_onLoadMoreConversations);
    on<RefreshChatConversationsEvent>(_onRefreshConversations);
    on<FilterChatConversationsEvent>(_onFilterConversations);
    on<SubscribeToChannelsEvent>(_onSubscribeToChannels);
    on<UnsubscribeFromChannelsEvent>(_onUnsubscribeFromChannels);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
    on<MarkChannelAsReadEvent>(_onMarkChannelAsRead);
    
    // Carregar opções de filtros
    _loadFilterOptions();
    
    // Escutar mensagens em tempo real
    _listenToMessages();
  }
  
  Future<void> _loadFilterOptions() async {
    final result = await _getFilterOptionsUseCase();
    result.fold(
      (failure) => null, // Ignora erro silenciosamente
      (options) => filterOptions = options,
    );
  }

  Future<void> _onLoadConversations(
    LoadChatConversationsEvent event,
    Emitter<ChatConversationsState> emit,
  ) async {
    emit(const ChatConversationsLoadingState());

    // Usar data atual se não for fornecida
    final now = DateTime.now();
    final dayCurrent = event.dayCurrent ?? 
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final result = await _getChatChannelsUseCase(
      GetChatChannelsRequest(
        dayCurrent: dayCurrent,
        status: event.status,
        typeTask: event.typeTask,
        assetIds: event.assetIds,
        localIds: event.localIds,
        responsibleIds: event.responsibleIds,
        first: 10, // Carregar 10 itens por vez
      ),
    );

    result.fold(
      (failure) => emit(ChatConversationsErrorState(failure.toString())),
      (response) async {
        if (response.channels.isEmpty) {
          emit(const ChatConversationsEmptyState());
        } else {
          emit(ChatConversationsLoadedState(
            response.channels,
            pageInfo: response.pageInfo,
            ttJwtToken: response.ttJwtToken,
          ));
          
          // Subscribe em todos os canais para receber mensagens em tempo real
          if (response.ttJwtToken != null && response.ttJwtToken!.isNotEmpty) {
            final channelIds = response.channels.map((c) => c.id).toList();
            add(SubscribeToChannelsEvent(
              channelIds: channelIds,
              jwtToken: response.ttJwtToken!,
            ));
          }
        }
      },
    );
  }

  Future<void> _onLoadMoreConversations(
    LoadMoreConversationsEvent event,
    Emitter<ChatConversationsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatConversationsLoadedState) return;

    // Usar data atual se não for fornecida
    final now = DateTime.now();
    final dayCurrent = event.dayCurrent ?? 
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final result = await _getChatChannelsUseCase(
      GetChatChannelsRequest(
        dayCurrent: dayCurrent,
        status: event.status,
        typeTask: event.typeTask,
        assetIds: event.assetIds,
        localIds: event.localIds,
        responsibleIds: event.responsibleIds,
        first: 10, // Carregar 10 itens por vez
        after: event.endCursor, // Usar cursor para próxima página
      ),
    );

    result.fold(
      (failure) {
        // Manter estado atual em caso de erro
      },
      (response) {
        // Adicionar novas conversas às existentes
        final allConversations = [
          ...currentState.conversations,
          ...response.channels,
        ];
        emit(ChatConversationsLoadedState(
          allConversations,
          pageInfo: response.pageInfo,
        ));
      },
    );
  }

  Future<void> _onRefreshConversations(
    RefreshChatConversationsEvent event,
    Emitter<ChatConversationsState> emit,
  ) async {
    add(const LoadChatConversationsEvent());
  }

  Future<void> _onFilterConversations(
    FilterChatConversationsEvent event,
    Emitter<ChatConversationsState> emit,
  ) async {
    add(LoadChatConversationsEvent(
      status: event.status,
      typeTask: event.typeTask,
      assetIds: event.assetIds,
      localIds: event.localIds,
      responsibleIds: event.responsibleIds,
    ));
  }

  String _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return '';
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(decoded) as Map<String, dynamic>;
      
      return payloadMap['user']?.toString() ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> _onSubscribeToChannels(
    SubscribeToChannelsEvent event,
    Emitter<ChatConversationsState> emit,
  ) async {
    try {
      // Extrair userId do token
      final userId = _extractUserIdFromToken(event.jwtToken);
      
      // Primeiro, conectar o WebSocket se ainda não estiver conectado
      await _chatRepository.connectWebSocket(
        jwtToken: event.jwtToken,
        userId: userId,
      );
      
      debugPrint('✅ WebSocket conectado para lista de conversas');

      // Depois, fazer subscribe em cada canal
      for (final channelId in event.channelIds) {
        if (!_subscribedChannels.contains(channelId)) {
          await _subscribeToChannelUseCase(
            SubscribeToChannelRequest(
              channelId: channelId,
              jwtToken: event.jwtToken,
            ),
          );
          _subscribedChannels.add(channelId);
          debugPrint('✅ Subscribe no canal: $channelId');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao fazer subscribe nos canais: $e');
    }
  }

  Future<void> _onUnsubscribeFromChannels(
    UnsubscribeFromChannelsEvent event,
    Emitter<ChatConversationsState> emit,
  ) async {
    for (final channelId in event.channelIds) {
      if (_subscribedChannels.contains(channelId)) {
        await _unsubscribeFromChannelUseCase(
          UnsubscribeFromChannelRequest(channelId: channelId),
        );
        _subscribedChannels.remove(channelId);
      }
    }
  }

  void _onNewMessageReceived(
    NewMessageReceivedEvent event,
    Emitter<ChatConversationsState> emit,
  ) {
    debugPrint(
        '📬 Lista de conversas recebeu nova mensagem: ${event.message.id} para canal: ${event.message.channelId}');

    final currentState = state;
    if (currentState is! ChatConversationsLoadedState) {
      debugPrint('⚠️ Estado não é ChatConversationsLoadedState');
      return;
    }

    // Atualizar a conversa com a nova mensagem
    final updatedConversations = currentState.conversations.map((conversation) {
      if (conversation.id == event.message.channelId) {
        debugPrint('✅ Atualizando card da conversa: ${conversation.id}');
        // Converter ChatMessageEntity para ChannelLastMessageEntity
        final author = MessageAuthorEntity(
          id: event.message.author.id,
          name: event.message.author.name,
          email: event.message.author.email,
        );
        
        final newLastMessage = ChannelLastMessageEntity(
          id: event.message.id,
          content: event.message.content,
          createdAt: event.message.createdAt,
          author: author,
        );
        
        // Marcar como não lida
        return conversation.copyWith(
          lastMessage: newLastMessage,
          hasUnreadMessages: true,
        );
      }
      return conversation;
    }).toList();
    
    emit(ChatConversationsLoadedState(
      updatedConversations,
      pageInfo: currentState.pageInfo,
      ttJwtToken: currentState.ttJwtToken,
    ));
  }

  void _onMarkChannelAsRead(
    MarkChannelAsReadEvent event,
    Emitter<ChatConversationsState> emit,
  ) {
    final currentState = state;
    if (currentState is! ChatConversationsLoadedState) return;
    
    // Marcar canal como lido
    final updatedConversations = currentState.conversations.map((conversation) {
      if (conversation.id == event.channelId) {
        return conversation.copyWith(hasUnreadMessages: false);
      }
      return conversation;
    }).toList();
    
    emit(ChatConversationsLoadedState(
      updatedConversations,
      pageInfo: currentState.pageInfo,
      ttJwtToken: currentState.ttJwtToken,
    ));
  }

  void _listenToMessages() {
    _messagesSubscription = _chatRepository.messagesStream.listen(
      (message) {
        add(NewMessageReceivedEvent(message));
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    // Desinscrever de todos os canais
    for (final channelId in _subscribedChannels) {
      _unsubscribeFromChannelUseCase(
        UnsubscribeFromChannelRequest(channelId: channelId),
      );
    }
    _subscribedChannels.clear();
    return super.close();
  }
}
