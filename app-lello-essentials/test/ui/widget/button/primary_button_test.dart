import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  testWidgets('renderiza o texto e chama onPressed/onLongPress', (tester) async {
    var pressed = 0;
    var long = 0;
    await pumpApp(
      tester,
      PrimaryButton(
        text: 'Confirmar',
        onPressed: () => pressed++,
        onLongPress: () => long++,
      ),
    );
    expect(find.text('Confirmar'), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.longPress(find.byType(ElevatedButton));
    expect(pressed, 1);
    expect(long, 1);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.style!.backgroundColor!.resolve({}),
        LightPallete().primary());
    expect(button.style!.padding!.resolve({}), EdgeInsets.zero);
    final shape = button.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(shape.side, BorderSide.none);
    expect(shape.borderRadius, BorderRadius.circular(8));

    final texto = tester.widget<Text>(find.text('Confirmar'));
    expect(texto.style!.color, LightPallete().buttonText());
    expect(texto.style!.fontWeight, FontWeight.w700);
  });

  testWidgets('sem texto nem filho renderiza string vazia', (tester) async {
    await pumpApp(tester, PrimaryButton(onPressed: () {}));
    expect(find.text(''), findsOneWidget);
    final container = tester.widget<Container>(find.byType(Container));
    expect(container.constraints?.maxHeight ?? 54.0, 54.0);
    expect(tester.getSize(find.byType(Container)).height, 54.0);
  });

  testWidgets('onPressed null desabilita o botão', (tester) async {
    await pumpApp(tester, const PrimaryButton(text: 'x', onPressed: null));
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isFalse);
  });

  testWidgets('filho customizado, cor, borda, padding, altura e largura',
      (tester) async {
    await pumpApp(
      tester,
      Center(
        child: PrimaryButton(
          onPressed: () {},
          child: const Icon(Icons.add, key: Key('icone')),
          buttonColor: Colors.green,
          border: const BorderSide(color: Colors.black, width: 2),
          padding: const EdgeInsets.all(4),
          height: 40,
          width: 120,
          textStyle: const TextStyle(color: Colors.yellow),
        ),
      ),
    );
    expect(find.byKey(const Key('icone')), findsOneWidget);
    expect(find.byType(Text), findsNothing);
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.style!.backgroundColor!.resolve({}), Colors.green);
    expect(button.style!.padding!.resolve({}), const EdgeInsets.all(4));
    final shape = button.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(shape.side.color, Colors.black);
    expect(shape.side.width, 2);
    final container = find.descendant(
        of: find.byType(ElevatedButton), matching: find.byType(Container));
    expect(tester.getSize(container), const Size(120, 40));
  });

  testWidgets('textStyle customizado substitui o estilo do tema',
      (tester) async {
    await pumpApp(
      tester,
      PrimaryButton(
        text: 'Estilo',
        onPressed: () {},
        textStyle: const TextStyle(color: Colors.yellow, fontSize: 30),
      ),
    );
    final texto = tester.widget<Text>(find.text('Estilo'));
    expect(texto.style!.color, Colors.yellow);
    expect(texto.style!.fontSize, 30);
  });

  testWidgets('golden do botão primário', (tester) async {
    await pumpApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(text: 'Primário', onPressed: () {}),
          const SizedBox(height: 8),
          const PrimaryButton(text: 'Desabilitado', onPressed: null),
        ],
      ),
      surface: const Size(400, 200),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/primary_button.png'));
  });
}
