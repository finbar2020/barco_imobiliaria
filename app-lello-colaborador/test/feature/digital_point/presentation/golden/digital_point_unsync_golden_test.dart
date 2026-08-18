import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/digital_point_unsychronized_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — pontos não sincronizados', (tester) async {
    final points = [
      testPoint(id: 1),
      testPoint(id: 2).copyWith(date: DateTime(2026, 1, 10, 12, 30)),
    ];

    await pumpApp(
      tester,
      DigitalPointsUnsynchronizedWidget(digitalPoints: points),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/digital_point_unsync_list.png'),
    );
  });

  testWidgets('lista vazia não renderiza linhas', (tester) async {
    await pumpApp(
      tester,
      const DigitalPointsUnsynchronizedWidget(digitalPoints: []),
      localized: true,
      surface: const Size(400, 200),
    );
    expect(find.byType(DigitalPointsUnsynchronizedWidget), findsOneWidget);
    expect(find.text('10/01/2026'), findsNothing);
  });
}
