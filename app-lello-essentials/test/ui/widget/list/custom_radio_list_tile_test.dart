import 'package:essentials/ui/widget/list/custom_radio_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  testWidgets('tocar na linha chama onChanged só quando muda o valor',
      (tester) async {
    final mudancas = <String?>[];
    await pumpApp(
      tester,
      Column(
        children: [
          CustomRadioListTile<String>(
            title: 'Opção A',
            groupValue: 'a',
            value: 'a',
            onChanged: mudancas.add,
          ),
          CustomRadioListTile<String>(
            title: 'Opção B',
            groupValue: 'a',
            value: 'b',
            onChanged: mudancas.add,
          ),
        ],
      ),
    );
    expect(find.text('Opção A'), findsOneWidget);
    expect(find.byType(Radio<String>), findsNWidgets(2));

    await tester.tap(find.text('Opção A'));
    expect(mudancas, isEmpty);
    await tester.tap(find.text('Opção B'));
    expect(mudancas, ['b']);
  });

  testWidgets('tocar no rádio chama onChanged com o novo valor',
      (tester) async {
    final mudancas = <int?>[];
    await pumpApp(
      tester,
      CustomRadioListTile<int>(
        title: 'Um',
        groupValue: 2,
        value: 1,
        onChanged: mudancas.add,
      ),
    );
    await tester.tap(find.byType(Radio<int>));
    expect(mudancas, [1]);
    expect(tester.getSize(find.byType(Radio<int>)), const Size(24, 24));
  });

  testWidgets('construtor custom usa titleWidget e padding', (tester) async {
    await pumpApp(
      tester,
      CustomRadioListTile<String>.custom(
        groupValue: null,
        value: 'x',
        onChanged: (_) {},
        titleWidget: const Icon(Icons.star, key: Key('estrela')),
        padding: const EdgeInsets.all(20),
      ),
    );
    expect(find.byKey(const Key('estrela')), findsOneWidget);
    expect(find.byType(Text), findsNothing);
    final padding = tester.widget<Padding>(find
        .descendant(of: find.byType(InkWell), matching: find.byType(Padding))
        .first);
    expect(padding.padding, const EdgeInsets.all(20));
  });

  testWidgets('padding padrão é 8 em cima e embaixo; título padrão vazio',
      (tester) async {
    await pumpApp(
      tester,
      CustomRadioListTile<String>(
        groupValue: 'a',
        value: 'a',
        onChanged: (_) {},
      ),
    );
    expect(find.text(''), findsOneWidget);
    final padding = tester.widget<Padding>(find
        .descendant(of: find.byType(InkWell), matching: find.byType(Padding))
        .first);
    expect(padding.padding, const EdgeInsets.only(top: 8.0, bottom: 8.0));
  });

  testWidgets('onChanged nulo é ignorado ao tocar', (tester) async {
    /// Corrigido: `onChanged` opcional é chamado com `?.call`, então tocar
    /// num item (ou no próprio rádio) sem callback não lança erro.
    await pumpApp(
      tester,
      CustomRadioListTile<String>(
        title: 'Sem callback',
        groupValue: 'a',
        value: 'b',
        onChanged: null,
      ),
    );
    await tester.tap(find.text('Sem callback'));
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(Radio<String>));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden dos rádios', (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          CustomRadioListTile<String>(
            title: 'Selecionado',
            groupValue: 'a',
            value: 'a',
            onChanged: (_) {},
          ),
          CustomRadioListTile<String>(
            title: 'Não selecionado',
            groupValue: 'a',
            value: 'b',
            onChanged: (_) {},
          ),
        ],
      ),
      surface: const Size(400, 160),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/custom_radio_list_tile.png'));
  });
}
