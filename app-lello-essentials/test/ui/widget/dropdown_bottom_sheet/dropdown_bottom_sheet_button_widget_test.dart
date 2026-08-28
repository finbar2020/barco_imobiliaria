import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_body_widget.dart';
import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_button_widget.dart';
import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

/// `T = dynamic`: com tipo concreto o "feito" do corpo lança (defeito
/// documentado em dropdown_bottom_sheet_body_widget_test.dart).
final _elementos = <DropdownBottomSheetElement<dynamic>>[
  DropdownBottomSheetElement<dynamic>(text: 'Um', value: 1),
  DropdownBottomSheetElement<dynamic>(text: 'Dois', value: 2),
];

void main() {
  testWidgets('texto exibido segue a prioridade valueText > hintText > title',
      (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          DropdownBottomSheetButton<dynamic>(
            key: const Key('valor'),
            dropDownElements: _elementos,
            doneFunction: (_) {},
            title: 'Título',
            hintText: 'Dica',
            valueText: 'Valor',
          ),
          DropdownBottomSheetButton<dynamic>(
            key: const Key('dica'),
            dropDownElements: _elementos,
            doneFunction: (_) {},
            title: 'Título',
            hintText: 'Dica',
          ),
          DropdownBottomSheetButton<dynamic>(
            key: const Key('titulo'),
            dropDownElements: _elementos,
            doneFunction: (_) {},
            title: 'Título',
            maxLines: 2,
          ),
          DropdownBottomSheetButton<dynamic>(
            key: const Key('vazio'),
            dropDownElements: _elementos,
            doneFunction: (_) {},
          ),
        ],
      ),
    );

    Text texto(Key key) => tester.widget<Text>(
          find.descendant(of: find.byKey(key), matching: find.byType(Text)),
        );

    expect(texto(const Key('valor')).data, 'Valor');
    expect(texto(const Key('dica')).data, 'Dica');
    expect(texto(const Key('titulo')).data, 'Título');
    expect(texto(const Key('titulo')).maxLines, 2);
    expect(texto(const Key('vazio')).data, '');
    expect(texto(const Key('vazio')).maxLines, isNull);
    expect(find.byIcon(Icons.arrow_drop_down), findsNWidgets(4));

    // Com valor usa a cor de texto normal; sem valor a cor opaca.
    expect(
      texto(const Key('valor')).style!.color,
      isNot(texto(const Key('dica')).style!.color),
    );
  });

  testWidgets('tocar abre o bottom sheet com o título (ou vazio) e devolve a escolha',
      (tester) async {
    DropdownBottomSheetElement? escolhido;
    await pumpApp(
      tester,
      DropdownBottomSheetButton<dynamic>(
        dropDownElements: _elementos,
        doneFunction: (e) => escolhido = e,
        title: 'Escolha um',
        showFilter: false,
      ),
    );

    await tester.tap(find.byType(DropdownBottomSheetButton<dynamic>));
    await tester.pumpAndSettle();

    final corpo = tester.widget<DropdownBottomSheetBodyWidget<dynamic>>(
      find.byType(DropdownBottomSheetBodyWidget<dynamic>),
    );
    expect(corpo.title, 'Escolha um');
    expect(corpo.showFilter, isFalse);
    expect(corpo.dropDownElements, same(_elementos));

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();
    expect(escolhido?.value, 1);
    expect(find.byType(DropdownBottomSheetBodyWidget<dynamic>), findsNothing);
  });

  testWidgets('sem título o bottom sheet abre com título vazio',
      (tester) async {
    await pumpApp(
      tester,
      DropdownBottomSheetButton<dynamic>(
        dropDownElements: _elementos,
        doneFunction: (_) {},
      ),
    );
    await tester.tap(find.byType(DropdownBottomSheetButton<dynamic>));
    await tester.pumpAndSettle();
    final corpo = tester.widget<DropdownBottomSheetBodyWidget<dynamic>>(
      find.byType(DropdownBottomSheetBodyWidget<dynamic>),
    );
    expect(corpo.title, '');
    expect(corpo.showFilter, isTrue);
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          DropdownBottomSheetButton<dynamic>(
            dropDownElements: _elementos,
            doneFunction: (_) {},
            hintText: 'Selecione o tipo',
          ),
          const SizedBox(height: 16),
          DropdownBottomSheetButton<dynamic>(
            dropDownElements: _elementos,
            doneFunction: (_) {},
            valueText: 'Apartamento',
          ),
        ],
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/dropdown_bottom_sheet_button.png'),
    );
  });
}
