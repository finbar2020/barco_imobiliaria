import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  testWidgets('fundo branco, borda e texto na cor primária', (tester) async {
    var pressed = 0;
    var long = 0;
    await pumpApp(
      tester,
      InvertedPrimaryButton(
        text: 'Invertido',
        onPressed: () => pressed++,
        onLongPress: () => long++,
      ),
    );
    await tester.tap(find.text('Invertido'));
    await tester.longPress(find.text('Invertido'));
    expect(pressed, 1);
    expect(long, 1);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.style!.backgroundColor!.resolve({}),
        LightPallete().background());
    final shape = button.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(shape.side.color, LightPallete().primary());
    expect(button.style!.padding!.resolve({}), EdgeInsets.zero);
    final texto = tester.widget<Text>(find.text('Invertido'));
    expect(texto.style!.color, LightPallete().primary());
    expect(tester.getSize(find.byType(Container)).height, 54.0);
  });

  testWidgets('buttonColor, border, padding, textStyle, tamanho e filho',
      (tester) async {
    await pumpApp(
      tester,
      Center(
        child: InvertedPrimaryButton(
          onPressed: () {},
          buttonColor: Colors.purple,
          border: const BorderSide(color: Colors.orange, width: 3),
          padding: const EdgeInsets.all(2),
          height: 30,
          width: 100,
          child: const Text('filho'),
        ),
      ),
    );
    expect(find.text('filho'), findsOneWidget);
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final shape = button.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(shape.side.color, Colors.orange);
    expect(shape.side.width, 3);
    expect(button.style!.padding!.resolve({}), const EdgeInsets.all(2));
    final container = find.descendant(
        of: find.byType(ElevatedButton), matching: find.byType(Container));
    expect(tester.getSize(container), const Size(100, 30));
  });

  testWidgets('buttonColor pinta borda e texto; textStyle tem prioridade',
      (tester) async {
    await pumpApp(
      tester,
      InvertedPrimaryButton(
        onPressed: () {},
        text: 'Cor',
        buttonColor: Colors.purple,
      ),
    );
    var button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    var shape = button.style!.shape!.resolve({}) as RoundedRectangleBorder;
    expect(shape.side.color, Colors.purple);
    expect(tester.widget<Text>(find.text('Cor')).style!.color, Colors.purple);

    await pumpApp(
      tester,
      InvertedPrimaryButton(
        onPressed: () {},
        text: 'Cor',
        buttonColor: Colors.purple,
        textStyle: const TextStyle(color: Colors.teal),
      ),
    );
    expect(tester.widget<Text>(find.text('Cor')).style!.color, Colors.teal);
  });

  testWidgets('sem texto renderiza string vazia e desabilita sem onPressed',
      (tester) async {
    await pumpApp(tester, const InvertedPrimaryButton(onPressed: null));
    expect(find.text(''), findsOneWidget);
    expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isFalse);
  });

  testWidgets('golden do botão primário invertido', (tester) async {
    await pumpApp(
      tester,
      InvertedPrimaryButton(text: 'Invertido', onPressed: () {}),
      surface: const Size(400, 120),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/inverted_primary_button.png'));
  });
}
