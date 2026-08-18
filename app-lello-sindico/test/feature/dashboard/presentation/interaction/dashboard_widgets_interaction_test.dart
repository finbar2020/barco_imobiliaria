import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/presentation/widgets/dashboard_pendency_list_item_v2.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('toque no item dispara onTap com a pendência', (tester) async {
    final entity = Pendency(
      id: 'p1',
      title: 'Aprovação de pagamento',
      message: 'Há 2 pagamentos aguardando a sua aprovação.',
      date: DateTime(2026, 1, 15),
      iconType: 'CIRCLE_GREEN',
    );
    Pendency? tapped;

    await pumpApp(
      tester,
      DashboardPendencyListItemV2(
        entity: entity,
        onTap: (item) => tapped = item,
      ),
      shrinkWrap: false,
      surface: const Size(400, 180),
    );

    await tester.tap(find.text('Aprovação de pagamento'));
    await tester.pump();
    expect(tapped?.id, 'p1');
  });
}
