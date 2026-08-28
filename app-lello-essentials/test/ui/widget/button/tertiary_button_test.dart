import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/button/tertiary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  testWidgets('texto com a cor de link e callbacks', (tester) async {
    var pressed = 0;
    var long = 0;
    await pumpApp(
      tester,
      TertiaryButton(
        text: 'Terciário',
        onPressed: () => pressed++,
        onLongPress: () => long++,
      ),
    );
    await tester.tap(find.text('Terciário'));
    await tester.longPress(find.text('Terciário'));
    expect(pressed, 1);
    expect(long, 1);
    final texto = tester.widget<Text>(find.text('Terciário'));
    expect(texto.style!.color, LightPallete().buttonLink());
    expect(texto.style!.fontWeight, FontWeight.w700);
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('style é mesclado ao estilo padrão', (tester) async {
    await pumpApp(
      tester,
      TertiaryButton(
        text: 'Cor',
        onPressed: () {},
        style: const TextStyle(color: Colors.green, fontSize: 40),
      ),
    );
    final texto = tester.widget<Text>(find.text('Cor'));
    expect(texto.style!.color, Colors.green);

    /// Corrigido: o `TextStyle` completo é mesclado ao estilo padrão — o
    /// fontSize passado (40) é aplicado e o peso padrão é mantido.
    expect(texto.style!.fontSize, 40);
    expect(texto.style!.fontWeight, FontWeight.w700);
  });

  testWidgets('style sem cor mantém a cor de link', (tester) async {
    await pumpApp(
      tester,
      TertiaryButton(
        text: 'SemCor',
        onPressed: () {},
        style: const TextStyle(fontSize: 40),
      ),
    );
    expect(tester.widget<Text>(find.text('SemCor')).style!.color,
        LightPallete().buttonLink());
  });

  testWidgets('filho customizado e texto nulo', (tester) async {
    await pumpApp(
      tester,
      TertiaryButton(
        onPressed: () {},
        child: const Icon(Icons.link, key: Key('link')),
      ),
    );
    expect(find.byKey(const Key('link')), findsOneWidget);
    expect(find.byType(Text), findsNothing);

    await pumpApp(tester, TertiaryButton(onPressed: () {}));
    expect(find.text(''), findsOneWidget);
  });

  testWidgets('golden do botão terciário', (tester) async {
    await pumpApp(
      tester,
      TertiaryButton(text: 'Terciário', onPressed: () {}),
      surface: const Size(400, 120),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/tertiary_button.png'));
  });
}
