import 'package:colaborador/feature/preferences/presentation/widget/preferences_checkbox.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_notification_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('tap no checkbox dispara onTap', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      PreferencesCheckBox(onTap: () => taps++, checked: false),
    );
    await tester.tap(find.byType(PreferencesCheckBox));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('golden — checkbox marcado e desmarcado', (tester) async {
    await pumpApp(
      tester,
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PreferencesNotificationCheckBox(
            onTap: _noop,
            checked: false,
            title: 'Avisos',
          ),
          SizedBox(height: 12),
          PreferencesNotificationCheckBox(
            onTap: _noop,
            checked: true,
            title: 'Avisos',
          ),
        ],
      ),
      localized: true,
      surface: const Size(400, 120),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/preferences_checkbox.png'),
    );
  });
}

void _noop() {}
