import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/presentation/widget/hub_badge.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — selo do hub', (tester) async {
    await pumpApp(
      tester,
      Align(
        alignment: Alignment.centerLeft,
        widthFactor: 1,
        heightFactor: 1,
        child: HubBadge(text: 'Novo'),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/hub_badge.png'),
    );
  });
}
