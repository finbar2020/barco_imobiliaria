import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../../../../../core/navigation/application_route.dart';
import '../bloc/chat_conversations_bloc.dart';
import '../bloc/chat_conversations_event.dart';
import '../bloc/chat_conversations_state.dart';
import 'chat_conversation_card_widget.dart';

/// Widget de seção de chat para integrar na tela de detalhes da tarefa
class ChatSectionWidget extends StatefulWidget {
  final String taskId;
  final VoidCallback? onViewAllConversations;

  const ChatSectionWidget({
    required this.taskId,
    this.onViewAllConversations,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatSectionWidget> createState() => _ChatSectionWidgetState();
}

class _ChatSectionWidgetState extends State<ChatSectionWidget> {
  late ChatConversationsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ChatConversationsBloc>();
    _bloc.add(LoadChatConversationsEvent(taskId: widget.taskId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocBuilder<ChatConversationsBloc, ChatConversationsState>(
      bloc: _bloc,
      builder: (context, state) {
        // Se estiver carregando ou em estado inicial, não mostra nada
        if (state is ChatConversationsInitialState ||
            state is ChatConversationsLoadingState) {
          return const SizedBox.shrink();
        }

        // Se estiver vazio, não mostra nada
        if (state is ChatConversationsEmptyState) {
          return const SizedBox.shrink();
        }

        // Se houver erro, mostra mensagem simples
        if (state is ChatConversationsErrorState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Erro ao carregar conversas',
              style: TextStyle(
                color: palette.error(),
                fontSize: 14,
              ),
            ),
          );
        }

        // Se houver conversas, mostra a seção
        if (state is ChatConversationsLoadedState) {
          final conversations = state.conversations;
          final displayCount = conversations.length > 2 ? 2 : conversations.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da seção
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Conversas',
                      style: TextStyle(
                        color: palette.text(),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (conversations.length > 2)
                      GestureDetector(
                        onTap: widget.onViewAllConversations,
                        child: Text(
                          'Ver todas',
                          style: TextStyle(
                            color: const Color(0xFF2F80ED),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Lista de conversas (máximo 2)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayCount,
                itemBuilder: (context, index) {
                  return ChatConversationCardWidget(
                    conversation: conversations[index],
                    onTap: () {
                      // Marcar como lido
                      _bloc.add(MarkChannelAsReadEvent(conversations[index].id));
                      
                      Navigator.of(context).pushNamed(
                        ApplicationRoute.maintenanceManagementChatMessages,
                        arguments: {
                          'channel': conversations[index],
                          'ttJwtToken': state.ttJwtToken,
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
