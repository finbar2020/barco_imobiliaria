import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:essentials/ui/widget/button/secondary_button.dart';
import 'package:essentials/ui/widget/button/tertiary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  Widget todos() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(text: 'Primário', onPressed: () {}),
          const SizedBox(height: 8),
          const PrimaryButton(text: 'Primário desabilitado', onPressed: null),
          const SizedBox(height: 8),
          InvertedPrimaryButton(text: 'Primário invertido', onPressed: () {}),
          const SizedBox(height: 8),
          SecondaryButton(text: 'Secundário', onPressed: () {}),
          const SizedBox(height: 8),
          SecondaryButton(
              text: 'Secundário azul',
              buttonBorderColor: Colors.blue,
              onPressed: () {}),
          const SizedBox(height: 8),
          TertiaryButton(text: 'Terciário', onPressed: () {}),
          PrimaryButton(
            onPressed: () {},
            height: 40,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text('Com ícone', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      );

  testWidgets('golden com todos os botões (tema claro)', (tester) async {
    await pumpApp(tester, todos(), surface: const Size(400, 520));
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('../../goldens/all_buttons.png'));
  });

  testWidgets('golden com todos os botões (tema escuro)', (tester) async {
    await pumpApp(tester, todos(), surface: const Size(400, 520), dark: true);
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/all_buttons_dark.png'));
  });
}
