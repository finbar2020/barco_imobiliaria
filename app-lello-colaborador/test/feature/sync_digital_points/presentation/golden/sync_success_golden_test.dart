import 'package:colaborador/feature/sync_digital_points/presentation/widget/sync_success_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — sync success', (tester) async {
    await pumpApp(
      tester,
      const SyncSuccessWidget(),
      localized: true,
      surface: const Size(400, 220),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/sync_success.png'),
    );
  });
}
