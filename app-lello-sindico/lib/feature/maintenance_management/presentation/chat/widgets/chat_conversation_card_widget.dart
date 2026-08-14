import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/chat/chat_channel_entity.dart';

/// Widget para exibir um card de conversa
class ChatConversationCardWidget extends StatelessWidget {
  final ChatChannelEntity conversation;
  final VoidCallback onTap;

  const ChatConversationCardWidget({
    required this.conversation,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  Color _getTypeColor(String type) {
    if (type.toUpperCase() == 'ROTINA') {
      return const Color(0xFF0058A0); // Azul Escuro
    } else {
      return const Color(0xFFE5073E); // Lello Primary Light
    }
  }

  String _getTypeLabel(String type) {
    if (type.toUpperCase() == 'ROTINA') {
      return 'ROTINA';
    } else {
      return 'ORDEM DE SERVIÇO';
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<ColorPallete>() ?? LightPallete();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFBEBEBE),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primeira linha: Tipo de tarefa e Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tipo de tarefa
                    Text(
                      _getTypeLabel(conversation.typeTask),
                      style: TextStyle(
                        color: _getTypeColor(conversation.typeTask),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // Status (à direita)
                    Row(
                      children: [
                        Container(
                          width: 8.17,
                          height: 8.17,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getStatusColor(conversation.status, palette),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatStatus(conversation.status),
                          style: TextStyle(
                            color: palette.grey(),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Título
                Text(
                  conversation.task.name,
                  style: TextStyle(
                    color: palette.text(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Última mensagem e Data relativa (só mostra se lastMessage não for null)
                if (conversation.lastMessage != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Indicador de mensagem não lida
                            if (conversation.hasUnreadMessages) ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE5073E), // Lello Primary Light
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                conversation.lastMessage!.content ?? 'Anexo',
                                style: TextStyle(
                                  color: conversation.lastMessage!.content == null 
                                      ? const Color(0xFF9E9E9E)
                                      : const Color(0xFF666666),
                                  fontSize: 15,
                                  fontWeight: conversation.hasUnreadMessages 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                  fontStyle: conversation.lastMessage!.content == null 
                                      ? FontStyle.italic 
                                      : FontStyle.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatRelativeDate(conversation.lastMessage!.createdAt),
                        style: TextStyle(
                          color: const Color(0xFF9E9E9E),
                          fontSize: 10,
                          fontWeight: conversation.hasUnreadMessages 
                              ? FontWeight.bold 
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
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

  String _formatRelativeDate(DateTime? date) {
    if (date == null) return 'Hoje';

    try {
      // Converte para timezone local
      final localDate = date.toLocal();
      
      // Normalizar datas para meia-noite (ignorar hora) para comparação correta
      final dateOnly = DateTime(localDate.year, localDate.month, localDate.day);
      final now = DateTime.now();
      final nowOnly = DateTime(now.year, now.month, now.day);
      
      final difference = nowOnly.difference(dateOnly).inDays;

      if (difference == 0) {
        return 'Hoje';
      } else if (difference == 1) {
        return 'Ontem';
      } else {
        // Formatar data como dd/MM/yyyy usando a data local
        final day = localDate.day.toString().padLeft(2, '0');
        final month = localDate.month.toString().padLeft(2, '0');
        final year = localDate.year.toString();
        return '$day/$month/$year';
      }
    } catch (e) {
      return 'Hoje';
    }
  }
}
