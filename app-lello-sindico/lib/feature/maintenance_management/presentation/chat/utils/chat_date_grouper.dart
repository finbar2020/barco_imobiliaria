import '../../../domain/entity/chat/chat_channel_entity.dart';

/// Modelo para agrupar conversas por data
class GroupedConversations {
  final String dateLabel; // "Hoje", "Ontem", "2 dias atrás", etc
  final DateTime date;
  final List<ChatChannelEntity> conversations;

  GroupedConversations({
    required this.dateLabel,
    required this.date,
    required this.conversations,
  });
}

/// Helper para agrupar conversas por data
class ChatDateGrouper {
  /// Agrupa conversas por data relativa (Hoje, Ontem, etc)
  static List<GroupedConversations> groupConversationsByDate(
    List<ChatChannelEntity> conversations,
  ) {
    if (conversations.isEmpty) {
      return [];
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Agrupar por data
    final Map<DateTime, List<ChatChannelEntity>> grouped = {};

    for (final conversation in conversations) {
      final messageDate = conversation.lastMessage?.createdAt ?? now;
      final conversationDate = DateTime(
        messageDate.year,
        messageDate.month,
        messageDate.day,
      );

      if (grouped[conversationDate] == null) {
        grouped[conversationDate] = [];
      }
      grouped[conversationDate]!.add(conversation);
    }

    // Ordenar por data (mais recente primeiro)
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    // Converter para GroupedConversations com labels
    return sortedDates.map((date) {
      String label;

      if (date == today) {
        label = 'Hoje';
      } else if (date == yesterday) {
        label = 'Ontem';
      } else {
        final daysAgo = today.difference(date).inDays;
        if (daysAgo < 7) {
          label = '$daysAgo dias atrás';
        } else if (daysAgo < 30) {
          final weeksAgo = (daysAgo / 7).floor();
          label = '$weeksAgo semana${weeksAgo > 1 ? 's' : ''} atrás';
        } else {
          final monthsAgo = (daysAgo / 30).floor();
          label = '$monthsAgo mês${monthsAgo > 1 ? 'es' : ''} atrás';
        }
      }

      return GroupedConversations(
        dateLabel: label,
        date: date,
        conversations: grouped[date]!,
      );
    }).toList();
  }

  /// Formata data para exibição
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final conversationDate = DateTime(date.year, date.month, date.day);

    if (conversationDate == today) {
      return 'Hoje';
    } else if (conversationDate == yesterday) {
      return 'Ontem';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}
