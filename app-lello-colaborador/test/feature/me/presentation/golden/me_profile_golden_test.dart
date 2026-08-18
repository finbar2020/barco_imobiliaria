import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — me profile buttons', (tester) async {
    await pumpApp(
      tester,
      MeProfileButtonsWidget(
        beginEditFunction: () {},
        deleteFunction: () {},
      ),
      localized: true,
      surface: const Size(400, 200),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/me_profile_buttons.png'),
    );
  });

  testWidgets('golden — me delete account dialog', (tester) async {
    await pumpApp(
      tester,
      MeProfileButtonsWidget(
        beginEditFunction: () {},
        deleteFunction: () {},
      ),
      localized: true,
      locOverrides: const {
        'comfort_disfavor_dialog_confirmation': 'OK',
        'delete_account_dialog_title': 'Titulo',
        'delete_account_dialog_subtitle': 'Sub',
        'delete_account_dialog_subtitle_complement': 'Comp',
      },
      surface: const Size(480, 720),
    );
    await tester.tap(find.text('delete_account'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await expectLater(
      find.byType(Dialog),
      matchesGoldenFile('goldens/me_delete_account_dialog.png'),
    );
  });
}
