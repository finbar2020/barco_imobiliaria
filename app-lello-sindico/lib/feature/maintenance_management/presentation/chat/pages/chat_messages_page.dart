import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart' hide User, Message, Image;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:shared_features/shared_features.dart';
import '../../../domain/entity/chat/chat_channel_entity.dart';
import '../../../domain/entity/chat/chat_message_entity.dart';
import '../../../data/service/websocket_service.dart';
import '../bloc/chat_messages_bloc.dart';
import '../bloc/chat_messages_event.dart';
import '../bloc/chat_messages_state.dart';
import '../../../../../core/dependency/application_container.dart';
import '../../../../../core/navigation/application_route.dart';
import '../../task/pages/file_preview_page.dart';

/// Página de mensagens de um chat específico
class ChatMessagesPage extends StatefulWidget {
  final ChatChannelEntity channel;
  final String? ttJwtToken;
  final String? taskId; // ID da tarefa (task_id) para navegação correta

  const ChatMessagesPage({
    required this.channel,
    this.ttJwtToken,
    this.taskId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  late ChatMessagesBloc _bloc;
  final InMemoryChatController _chatController = InMemoryChatController();
  String? _currentUserId;
  final Map<String, User> _userCache = {};
  final Set<String> _addedMessageIds =
      {}; // Rastrear IDs de mensagens já adicionadas
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ChatMessagesBloc>();
    _bloc.add(LoadChatMessagesEvent(channelId: widget.channel.id));

    // Conectar ao WebSocket para receber mensagens em tempo real
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    // Só conectar se tiver o token
    if (widget.ttJwtToken == null || widget.ttJwtToken!.isEmpty) {
      return;
    }

    try {
      final tokenDataSource =
          ApplicationContainer.instance().resolve<AccessTokenLocalDataSource>();
      final token = await tokenDataSource.select(role: "");

      if (token?.accessToken != null) {
        final webSocketService =
            ApplicationContainer.instance().resolve<WebSocketService>();

        // Extrair userId do token principal
        final userId = _extractUserIdFromToken(token!.accessToken!);

        // Conectar ao WebSocket usando o ttJwtToken
        await webSocketService.connect(
          jwtToken: widget.ttJwtToken!,
          userId: userId,
          isProduction: false,
        );

        // Subscribe no canal específico
        await webSocketService.subscribe(
          channelId: widget.channel.id,
          jwtToken: widget.ttJwtToken!,
        );
      }
    } catch (e) {
      // Ignora erros de conexão WebSocket
    }
  }

  String _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final normalizedPayload = payload.padRight(
          (payload.length + 3) ~/ 4 * 4,
          '=',
        );
        final decodedBytes = base64.decode(normalizedPayload);
        final decodedPayload = utf8.decode(decodedBytes);
        final payloadMap = jsonDecode(decodedPayload) as Map<String, dynamic>;
        return payloadMap['sub'] as String? ?? '';
      }
    } catch (e) {
      // Ignora erro
    }
    return '';
  }

  void _disconnectWebSocket() {
    try {
      final webSocketService =
          ApplicationContainer.instance().resolve<WebSocketService>();

      // Desinscrever sem await para evitar problemas no dispose
      webSocketService.unsubscribe(widget.channel.id);
    } catch (e) {
      // Ignora erro
    }
  }

  @override
  void dispose() {
    _disconnectWebSocket();
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isTaskCompleted() {
    return widget.channel.status.toUpperCase() == 'DONE';
  }

  Color _getStatusColor(String status, ColorPallete palette) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return palette.raffle(); // Em andamento
      case 'NOT_STARTED':
        return palette.warning(); // Pendente
      case 'DONE':
        return palette.success(); // Concluído
      default:
        return palette.grey();
    }
  }

  String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return 'Em andamento';
      case 'NOT_STARTED':
        return 'Pendente';
      case 'DONE':
        return 'Concluído';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Scaffold(
      backgroundColor: palette.background(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: palette.primary()),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: InkWell(
          onTap: () {
            // Se taskId NÃO foi passado, significa que veio da lista de conversas
            // Nesse caso, navega para os detalhes da tarefa
            if (widget.taskId == null) {
              Navigator.of(context).pushNamed(
                ApplicationRoute.maintenanceManagementTaskDetails,
                arguments: widget.channel.task.id,
              );
            } else {
              // Se taskId foi passado, veio dos detalhes
              // Apenas fecha o chat (pop) para voltar aos detalhes
              Navigator.of(context)
                  .pop(true); // true para indicar que deve recarregar
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.channel.task.name,
                style: TextStyle(
                  color: palette.text(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getStatusColor(widget.channel.status, palette),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatStatus(widget.channel.status),
                    style: TextStyle(
                      color: palette.grey(),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
        builder: (context, state) {
          if (state is ChatMessagesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatMessagesErrorState) {
            return ErrorHandlingWidget(
              isProduction: false,
              errorCode: 'CHAT_ERROR',
              error: state.message,
              message: 'Erro ao carregar mensagens',
              reTryFunction: () {
                _bloc.add(LoadChatMessagesEvent(channelId: widget.channel.id));
              },
              backFunction: () {
                Navigator.of(context).pop();
              },
            );
          }

          if (state is ChatMessagesLoadedState) {
            // Atualizar currentUserId da API após o build
            if (state.currentUserId != null &&
                _currentUserId != state.currentUserId) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _currentUserId = state.currentUserId;
                  });
                }
              });
            }
            // Converter e popular mensagens no controller
            _populateMessages(state.messages);
          }

          if (state is ChatMessagesEmptyState) {
            // Atualizar currentUserId mesmo quando vazio
            if (state.currentUserId != null &&
                _currentUserId != state.currentUserId) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _currentUserId = state.currentUserId;
                  });
                }
              });
            }
            // Inicializar com lista vazia para o Chat exibir o composer
            _populateMessages([]);
          }

          return Column(
            children: [
              Expanded(
                child: Chat(
                  chatController: _chatController,
                  currentUserId: _currentUserId ?? 'unknown',
                  theme: _buildChatTheme(theme, palette),
                  builders: Builders(
                      composerBuilder: (context) => _isTaskCompleted()
                          ? const SizedBox.shrink()
                          : _buildCustomComposer(theme, palette),
                      chatMessageBuilder: (context, message, index, animation, child,
                              {isRemoved, required isSentByMe, groupStatus}) =>
                          _buildCustomMessage(
                              context, message, child, isSentByMe, theme, palette),
                      imageMessageBuilder: (context, message, index,
                              {groupStatus, isSentByMe = false}) =>
                          _buildImageMessage(
                              context, message, isSentByMe, theme, palette),
                      fileMessageBuilder: (context, message, index,
                              {groupStatus, isSentByMe = false}) =>
                          _buildFileMessage(context, message, isSentByMe, theme, palette),
                      chatAnimatedListBuilder: (context, itemBuilder) => _buildChatListWithDateHeaders(context, itemBuilder, palette)),
                  backgroundColor: const Color(0xFFF5F5F5),
                  onMessageSend: (text) {
                    if (!_isTaskCompleted()) {
                      _bloc.add(SendChatMessageEvent(
                        channelId: widget.channel.id,
                        content: text,
                      ));
                    }
                  },
                  resolveUser: _resolveUser,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ChatTheme _buildChatTheme(ThemeData theme, ColorPallete palette) {
    // Cor baseada no tipo de tarefa: Azul para Rotina, Vermelho para Ordem de Serviço
    final messageColor = widget.channel.typeTask == 'ROTINA'
        ? const Color(0xFF0058A0) // Azul Rotina
        : palette.primary(); // Vermelho Ordem de Serviço

    return ChatTheme.fromThemeData(
      theme,
    ).copyWith(
      colors: ChatTheme.fromThemeData(theme).colors.copyWith(
            primary: messageColor,
          ),
      shape: const BorderRadius.all(Radius.circular(12)),
    );
  }

  Widget _buildCustomComposer(ThemeData theme, ColorPallete palette) {
    final textController = TextEditingController();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        color: const Color(0xFFF5F5F5),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Input de texto arredondado
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey[400]!, width: 1),
                  ),
                  child: TextField(
                    controller: textController,
                    enabled: !_isTaskCompleted(),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Mensagem',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botão de envio vermelho
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: palette.primary(),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 24),
                  onPressed: _isTaskCompleted()
                      ? null
                      : () {
                          final text = textController.text.trim();
                          if (text.isNotEmpty) {
                            _bloc.add(SendChatMessageEvent(
                              channelId: widget.channel.id,
                              content: text,
                            ));
                            textController.clear();
                          }
                        },
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomMessage(
    BuildContext context,
    Message message,
    Widget child,
    bool isSentByMe,
    ThemeData theme,
    ColorPallete palette,
  ) {
    // Buscar mensagem original para verificar status
    final currentState = _bloc.state;
    ChatMessageEntity? originalMessage;
    if (currentState is ChatMessagesLoadedState) {
      try {
        originalMessage = currentState.messages.firstWhere(
          (m) => m.id == message.id,
        );
      } catch (_) {}
    }

    // Mensagem enviada por mim - alinhar à direita com largura limitada
    if (isSentByMe) {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 8, top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Indicador de status (apenas erro, sem loading)
            if (originalMessage != null && originalMessage.isFailed)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    // Reenviar mensagem
                    _bloc.add(RetrySendMessageEvent(
                      messageId: originalMessage!.id,
                      channelId: widget.channel.id,
                      content: originalMessage.content ?? '',
                      attachmentId: originalMessage.attachment?.id,
                    ));
                  },
                  child: Tooltip(
                    message: 'Toque para reenviar',
                    child: Icon(
                      Icons.error_outline,
                      color: palette.error(),
                      size: 20,
                    ),
                  ),
                ),
              ),
            Flexible(
              child: child,
            ),
          ],
        ),
      );
    }

    // Mensagem recebida - adicionar avatar, nome e cargo
    return FutureBuilder<User>(
      future: _resolveUser(message.authorId),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 60, top: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: palette.primary().withValues(alpha: 0.1),
                backgroundImage: user?.imageSource != null
                    ? NetworkImage(user!.imageSource!)
                    : null,
                child: user?.imageSource == null
                    ? Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? '?',
                        style: TextStyle(
                          color: palette.primary(),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Nome, cargo e mensagem
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome e cargo
                    Row(
                      children: [
                        Text(
                          user?.name ?? 'Carregando...',
                          style: LelloTextStyles.body(theme)?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user?.metadata?['role']?.toString().toUpperCase() ??
                              '',
                          style: LelloTextStyles.caption(theme)?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Mensagem
                    child,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageMessage(
    BuildContext context,
    ImageMessage message,
    bool isSentByMe,
    ThemeData theme,
    ColorPallete palette,
  ) {
    // Se enviado por mim, alinhar à direita
    if (isSentByMe) {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 8, top: 8, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 250),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: palette.primary(),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  message.source,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Erro ao carregar imagem',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openImagePreview(message.source),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.source,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      color: palette.text(),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Erro ao carregar imagem',
                      style: TextStyle(color: palette.text()),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFileMessage(
    BuildContext context,
    FileMessage message,
    bool isSentByMe,
    ThemeData theme,
    ColorPallete palette,
  ) {
    // Extrair extensão do arquivo da URL
    final extension = _getFileExtension(message.name);

    final fileWidget = GestureDetector(
      onTap: () => _openFilePreview(message.source, message.name, extension),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSentByMe ? palette.primary() : Colors.grey[300],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getFileIcon(extension),
              color: isSentByMe ? Colors.white : palette.text(),
              size: 24,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : palette.text(),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.mimeType ?? 'arquivo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white70 : palette.textLight(),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Se enviado por mim, alinhar à direita
    if (isSentByMe) {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 8, top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [fileWidget],
        ),
      );
    }

    // Se recebido, mostrar com avatar e nome
    return fileWidget;
  }

  Widget _buildChatListWithDateHeaders(
      BuildContext context, ChatItem itemBuilder, ColorPallete palette) {
    final theme = Theme.of(context);
    // O dash_chat já ordena as mensagens de forma reversa (mais recentes primeiro)
    // Então usamos diretamente sem inverter
    final messages = _chatController.messages;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Lista de mensagens com separadores de data
              Padding(
                padding: EdgeInsets.only(
                  bottom: _isTaskCompleted() ? 16 : 80,
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: _calculateItemCount(messages),
                  itemBuilder: (context, index) {
                    return _buildItemWithDateHeader(
                        context, index, messages, itemBuilder, palette);
                  },
                ),
              ),
              // Nossa mensagem customizada sobrepõe a da lib quando vazio
              if (messages.isEmpty)
                Container(
                  color: const Color(0xFFF5F5F5), // Mesma cor do background
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: palette.textLight(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma mensagem ainda',
                            textAlign: TextAlign.center,
                            style: LelloTextStyles.subtitle(theme)?.copyWith(
                              color: palette.text(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Inicie a conversa enviando uma mensagem',
                            textAlign: TextAlign.center,
                            style: LelloTextStyles.body(theme)?.copyWith(
                              color: palette.textLight(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_isTaskCompleted())
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'TAREFA CONCLUÍDA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
      ],
    );
  }

  void _populateMessages(List<ChatMessageEntity> messages) {
    bool hasNewMessages = false;

    // Remover mensagens temporárias (sem ID da API) do usuário atual
    // Essas são mensagens otimísticas adicionadas pelo dash_chat
    final currentMessages = List<Message>.from(_chatController.messages);
    for (final msg in currentMessages) {
      // Se a mensagem é do usuário atual e tem ID temporário (UUID gerado localmente)
      if (msg.authorId == _currentUserId && msg.id.length < 36) {
        try {
          _chatController.removeMessage(msg);
        } catch (e) {
          // Ignora erro
        }
      }
    }

    // Adicionar apenas mensagens que ainda não foram adicionadas
    for (final message in messages) {
      // Verificar se a mensagem já foi adicionada
      if (_addedMessageIds.contains(message.id)) {
        continue; // Pular mensagens duplicadas
      }

      final chatMessage = _convertToChatMessage(message);
      if (chatMessage != null) {
        try {
          _chatController.insertMessage(chatMessage);
          _addedMessageIds.add(message.id); // Marcar como adicionada
          hasNewMessages = true;
        } catch (e) {
          // Ignora erro - mensagem pode já existir
        }

        // Adicionar usuário ao cache
        if (!_userCache.containsKey(message.authorId)) {
          _userCache[message.authorId] = User(
            id: message.authorId,
            name: message.author.name,
            imageSource: message.author.imageUrl,
            metadata: {
              'email': message.author.email,
              'username': message.author.username ?? '',
              'role': message.author.profile?.name ?? 'USUÁRIO',
              'roleDescription': message.author.profile?.description ?? '',
            },
          );
        }
      }
    }

    // Rolar para o final se houver novas mensagens
    if (hasNewMessages) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Message? _convertToChatMessage(ChatMessageEntity message) {
    try {
      // Converter baseado no tipo de mensagem
      switch (message.messageType.toUpperCase()) {
        case 'TEXT':
          return TextMessage(
            id: message.id,
            authorId: message.authorId,
            createdAt: message.createdAt.toUtc(),
            text: message.content ?? '',
          );

        case 'ATTACHMENT':
          if (message.attachment != null) {
            // Determinar tipo de anexo baseado no attachmentType ou extensão
            final attachmentType =
                message.attachment!.attachmentType?.toUpperCase();
            final isImage = attachmentType == 'IMAGE' ||
                _isImageUrl(message.attachment!.url);

            if (isImage) {
              return ImageMessage(
                id: message.id,
                authorId: message.authorId,
                createdAt: message.createdAt.toUtc(),
                source: message.attachment!.url,
              );
            } else {
              return FileMessage(
                id: message.id,
                authorId: message.authorId,
                createdAt: message.createdAt.toUtc(),
                source: message.attachment!.url,
                name: message.attachment!.name,
                mimeType: _getMimeTypeFromUrl(message.attachment!.url),
              );
            }
          } else {
            // Se attachment é null mas messageType é ATTACHMENT, log de debug
            debugPrint(
                '⚠️ Mensagem ATTACHMENT sem attachment data: ${message.id}');
          }
          break;
      }

      // Fallback para mensagem de texto (apenas se não for ATTACHMENT sem dados)
      if (message.messageType.toUpperCase() != 'ATTACHMENT' ||
          message.attachment == null) {
        return TextMessage(
          id: message.id,
          authorId: message.authorId,
          createdAt: message.createdAt.toUtc(),
          text: message.content ?? '',
        );
      }

      return null;
    } catch (e) {
      debugPrint('❌ Erro ao converter mensagem ${message.id}: $e');
      // Fallback seguro: retorna TextMessage vazia ao invés de null
      return TextMessage(
        id: message.id,
        authorId: message.authorId,
        createdAt: message.createdAt.toUtc(),
        text: '[Erro ao carregar mensagem]',
      );
    }
  }

  bool _isImageUrl(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerUrl = url.toLowerCase();
    return imageExtensions.any((ext) => lowerUrl.contains(ext));
  }

  String? _getMimeTypeFromUrl(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.endsWith('.pdf')) return 'application/pdf';
    if (lowerUrl.endsWith('.doc') || lowerUrl.endsWith('.docx')) {
      return 'application/msword';
    }
    if (lowerUrl.endsWith('.xls') || lowerUrl.endsWith('.xlsx')) {
      return 'application/vnd.ms-excel';
    }
    return null;
  }

  Future<User> _resolveUser(String userId) async {
    try {
      // Verificar cache primeiro
      if (_userCache.containsKey(userId)) {
        return _userCache[userId]!;
      }

      // Se não estiver no cache, retornar usuário genérico
      // TODO: Buscar na API se necessário
      final user = User(
        id: userId,
        name: 'Usuário',
      );

      _userCache[userId] = user;
      return user;
    } catch (e) {
      debugPrint('Erro ao resolver usuário: $e');
      return User(
        id: userId,
        name: 'Usuário',
      );
    }
  }

  int _calculateItemCount(List<Message> messages) {
    if (messages.isEmpty) return 0;

    int count = messages.length;
    // Sempre mostrar header para a primeira mensagem
    count++;
    // Adicionar separadores de data quando a data muda
    for (int i = 1; i < messages.length; i++) {
      if (_shouldShowDateHeader(messages[i - 1], messages[i])) {
        count++;
      }
    }

    return count;
  }

  bool _shouldShowDateHeader(Message current, Message next) {
    final currentCreatedAt = current.createdAt;
    final nextCreatedAt = next.createdAt;

    if (currentCreatedAt == null || nextCreatedAt == null) return false;

    final currentDate = DateTime(
      currentCreatedAt.year,
      currentCreatedAt.month,
      currentCreatedAt.day,
    );
    final nextDate = DateTime(
      nextCreatedAt.year,
      nextCreatedAt.month,
      nextCreatedAt.day,
    );
    return currentDate != nextDate;
  }

  Widget _buildItemWithDateHeader(
    BuildContext context,
    int index,
    List<Message> messages,
    ChatItem itemBuilder,
    ColorPallete palette,
  ) {
    // Calcular índice real da mensagem considerando os headers
    int messageIndex = 0;
    int headerCount = 0;

    // Contar quantos headers existem antes deste índice
    for (int i = 0; i < messages.length; i++) {
      if (messageIndex + headerCount == index) {
        // Verificar se deve mostrar header ANTES desta mensagem
        // Mostra header se for a primeira mensagem OU se a data mudou em relação à anterior
        final shouldShowHeader = i == 0 ||
            (i > 0 && _shouldShowDateHeader(messages[i - 1], messages[i]));

        if (shouldShowHeader) {
          return Column(
            children: [
              _buildDateHeader(
                  messages[i].createdAt ?? DateTime.now(), palette),
              itemBuilder(
                  context, messages[i], i, const AlwaysStoppedAnimation(1.0)),
            ],
          );
        } else {
          return itemBuilder(
              context, messages[i], i, const AlwaysStoppedAnimation(1.0));
        }
      }

      messageIndex++;
      if (i > 0 && _shouldShowDateHeader(messages[i - 1], messages[i])) {
        headerCount++;
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildDateHeader(DateTime date, ColorPallete palette) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;

    if (messageDate == today) {
      dateText = 'HOJE';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      dateText = 'ONTEM';
    } else {
      // Formato: 27/10/2025
      dateText =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      alignment: Alignment.center,
      child: Text(
        dateText,
        style: TextStyle(
          color: palette.text(),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _openImagePreview(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilePreviewPage(
          url: imageUrl,
          filename: 'Imagem',
          extension: 'jpg',
        ),
      ),
    );
  }

  void _openFilePreview(String fileUrl, String filename, String extension) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilePreviewPage(
          url: fileUrl,
          filename: filename,
          extension: extension,
        ),
      ),
    );
  }

  String _getFileExtension(String filename) {
    if (filename.contains('.')) {
      return filename.split('.').last.toLowerCase();
    }
    return 'arquivo';
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
