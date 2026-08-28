import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/button/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  testWidgets('borda da paleta, texto centralizado e callbacks',
      (tester) async {
    var pressed = 0;
    var long = 0;
    await pumpApp(
      tester,
      SecondaryButton(
        text: 'Secundário',
        onPressed: () => pressed++,
        onLongPress: () => long++,
      ),
    );
    await tester.tap(find.text('Secundário'));
    await tester.longPress(find.text('Secundário'));
    expect(pressed, 1);
    expect(long, 1);

    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    final side = button.style!.side!.resolve({})!;
    expect(side.color, LightPallete().secondaryButtonBorder());
    expect(side.width, 1);
    final shape = button.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(8));

    final texto = tester.widget<Text>(find.text('Secundário'));
    expect(texto.textAlign, TextAlign.center);
    expect(texto.style!.color, LightPallete().text());
    expect(texto.style!.fontWeight, FontWeight.w700);
    expect(tester.getSize(find.byType(Container)).height, 54.0);
  });

  testWidgets('buttonBorderColor pinta borda e texto; height custom',
      (tester) async {
    await pumpApp(
      tester,
      SecondaryButton(
        text: 'Cor',
        onPressed: () {},
        buttonBorderColor: Colors.blue,
        height: 40,
      ),
    );
    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.style!.side!.resolve({})!.color, Colors.blue);
    expect(tester.widget<Text>(find.text('Cor')).style!.color, Colors.blue);
    expect(tester.getSize(find.byType(Container)).height, 40.0);
  });

  testWidgets('filho customizado e height nulo', (tester) async {
    await pumpApp(
      tester,
      SecondaryButton(
        onPressed: () {},
        height: null,
        child: const Icon(Icons.star, key: Key('estrela')),
      ),
    );
    expect(find.byKey(const Key('estrela')), findsOneWidget);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('sem texto renderiza vazio; onPressed null desabilita',
      (tester) async {
    await pumpApp(tester, const SecondaryButton(onPressed: null));
    expect(find.text(''), findsOneWidget);
    expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).enabled,
        isFalse);
  });

  testWidgets('no tema escuro usa a borda da paleta escura', (tester) async {
    await pumpApp(tester, SecondaryButton(text: 'Dark', onPressed: () {}),
        dark: true);
    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.style!.side!.resolve({})!.color,
        DarkPallete().secondaryButtonBorder());
  });

  testWidgets('golden do botão secundário', (tester) async {
    await pumpApp(
      tester,
      SecondaryButton(text: 'Secundário', onPressed: () {}),
      surface: const Size(400, 120),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/secondary_button.png'));
  });
}
