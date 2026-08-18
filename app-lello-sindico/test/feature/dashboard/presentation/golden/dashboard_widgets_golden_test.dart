import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/presentation/widgets/dashboard_pendency_list_item_v2.dart';

import '../../../../helpers/pump_app.dart';

Pendency _pendency({
  String iconType = 'CIRCLE_ORANGE',
  String title = 'Aprovação de pagamento',
  String message = 'Há 2 pagamentos aguardando a sua aprovação.',
}) {
  return Pendency(
    id: 'p1',
    title: title,
    message: message,
    date: DateTime(2026, 1, 15),
    iconType: iconType,
    read: false,
  );
}

void main() {
  testWidgets('golden — item de pendência', (tester) async {
    await pumpApp(
      tester,
      DashboardPendencyListItemV2(entity: _pendency()),
      shrinkWrap: false,
      surface: const Size(400, 180),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/pendency_item.png'),
    );
  });

  testWidgets('golden — item de pendência urgente', (tester) async {
    await pumpApp(
      tester,
      DashboardPendencyListItemV2(
        entity: _pendency(
          iconType: 'CIRCLE_RED',
          title: 'Prestação em atraso',
          message: 'A prestação de contas de dezembro precisa de atenção.',
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 180),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/pendency_item_urgent.png'),
    );
  });

  testWidgets('golden — item de pendência concluída', (tester) async {
    await pumpApp(
      tester,
      DashboardPendencyListItemV2(
        entity: _pendency(
          iconType: 'CIRCLE_GREEN',
          title: 'Prestação aprovada',
          message: 'A prestação de contas foi concluída.',
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 180),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/pendency_item_green.png'),
    );
  });

  testWidgets('golden — item de pendência com ícone padrão', (tester) async {
    await pumpApp(
      tester,
      DashboardPendencyListItemV2(entity: _pendency(iconType: 'UNKNOWN')),
      shrinkWrap: false,
      surface: const Size(400, 180),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/pendency_item_default.png'),
    );
  });
}
