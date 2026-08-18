import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_channel_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/chat/widgets/chat_conversation_card_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/create_task/widgets/equipment_selection_widget.dart';

import '../../../../helpers/pump_app.dart';

ChatChannelEntity _channel({
  String type = 'ROTINA',
  String status = 'DRAFT',
  String taskName = 'Limpeza da piscina',
  ChannelLastMessageEntity? lastMessage,
  bool unread = false,
}) {
  return ChatChannelEntity(
    id: 'c1',
    typeTask: type,
    status: status,
    task: ChannelTaskEntity(id: 't1', name: taskName),
    lastMessage: lastMessage,
    hasUnreadMessages: unread,
  );
}

void main() {
  testWidgets('golden — conversa de rotina em andamento', (tester) async {
    await pumpApp(
      tester,
      ChatConversationCardWidget(
        conversation: _channel(
          lastMessage: ChannelLastMessageEntity(
            id: 'm1',
            content: 'Piscina higienizada.',
            createdAt: DateTime.now(),
            author: const MessageAuthorEntity(
              id: 'a1',
              name: 'Ana',
              email: 'ana@condo.com',
            ),
          ),
        ),
        onTap: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/chat_card_routine.png'),
    );
  });

  testWidgets('golden — OS concluída com anexo não lido', (tester) async {
    await pumpApp(
      tester,
      ChatConversationCardWidget(
        conversation: _channel(
          type: 'OS',
          status: 'DONE',
          taskName: 'Troca de lâmpada',
          unread: true,
          lastMessage: ChannelLastMessageEntity(
            id: 'm2',
            createdAt: DateTime(2020, 1, 15, 10),
            author: const MessageAuthorEntity(
              id: 'a2',
              name: 'João',
              email: 'joao@condo.com',
            ),
          ),
        ),
        onTap: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/chat_card_os_done.png'),
    );
  });

  testWidgets('golden — conversa pendente sem mensagem', (tester) async {
    await pumpApp(
      tester,
      ChatConversationCardWidget(
        conversation: _channel(status: 'NOT_STARTED'),
        onTap: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/chat_card_pending.png'),
    );
  });

  testWidgets('golden — status desconhecido', (tester) async {
    await pumpApp(
      tester,
      ChatConversationCardWidget(
        conversation: _channel(status: 'ARCHIVED'),
        onTap: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/chat_card_archived.png'),
    );
  });

  testWidgets('golden — seletor de equipamento vazio', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return EquipmentSelectionWidget(
            selectedEquipment: null,
            availableEquipments: const [],
            onEquipmentSelected: (_) {},
            theme: theme,
            palette: LelloTheme.palleteOf(theme),
          );
        },
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/equipment_selector_empty.png'),
    );
  });

  testWidgets('golden — seletor de equipamento preenchido', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return EquipmentSelectionWidget(
            selectedEquipment: FilterAssetEntity(id: 'e1', name: 'Bomba d\'água'),
            availableEquipments: [
              FilterAssetEntity(id: 'e1', name: 'Bomba d\'água'),
            ],
            onEquipmentSelected: (_) {},
            theme: theme,
            palette: LelloTheme.palleteOf(theme),
          );
        },
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/equipment_selector_filled.png'),
    );
  });
}
