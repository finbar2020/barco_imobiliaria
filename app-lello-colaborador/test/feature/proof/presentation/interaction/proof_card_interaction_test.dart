import 'package:colaborador/feature/proof/presentation/widgets/proof_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tap no card dispara onTap', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      ProofCardWidget(
        onTap: () => taps++,
        dateTimeClockIn: '10/01/2026 08:00',
      ),
      localized: true,
    );
    await tester.tap(find.byType(ProofCardWidget));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('golden — proof card', (tester) async {
    await pumpApp(
      tester,
      ProofCardWidget(
        onTap: () {},
        dateTimeClockIn: '10/01/2026 08:00',
      ),
      localized: true,
      surface: const Size(400, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/proof_card.png'),
    );
  });
}
