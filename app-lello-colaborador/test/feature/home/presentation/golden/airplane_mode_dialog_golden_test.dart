import 'package:colaborador/feature/home/presentation/widget/airplane_mode_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — airplane mode dialog', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () => AirplaneModeDialog.show(context),
            child: const Text('open'),
          );
        },
      ),
      localized: true,
      surface: const Size(400, 360),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(Dialog),
      matchesGoldenFile('goldens/airplane_mode_dialog.png'),
    );
  });
}
