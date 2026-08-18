import 'package:colaborador/feature/me/presentation/pages/me_edit_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — me edit success', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        initialRoute: '/',
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: RouteSettings(
            arguments: MeEditSuccessPageArgs(onConfirm: () {}),
          ),
          builder: (_) => const MeEditSuccessPage(),
        ),
      ),
      localized: true,
      wrapInScaffold: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/me_edit_success.png'),
    );
  });
}
