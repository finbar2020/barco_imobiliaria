import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet.dart';
import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_body_widget.dart';
import 'package:essentials/ui/widget/dropdown_bottom_sheet/dropdown_bottom_sheet_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('show com T tipado abre o corpo tipado', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => DropdownBottomSheet.show<int>(
            context: context,
            title: 'Tipado',
            dropDownElements: [
              DropdownBottomSheetElement<int>(text: 'Um', value: 1),
            ],
            doneFunction: (_) {},
          ),
          child: const Text('abrir'),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.byType(DropdownBottomSheetBodyWidget<int>), findsOneWidget);
    expect(
      tester
          .widget<DropdownBottomSheetBodyWidget<int>>(
              find.byType(DropdownBottomSheetBodyWidget<int>))
          .showFilter,
      isTrue,
    );
  });

  testWidgets('show abre um bottom sheet com o corpo e repassa os parâmetros',
      (tester) async {
    DropdownBottomSheetElement? escolhido;
    // `T = dynamic`: com tipo concreto o "feito" lança (defeito documentado
    // em dropdown_bottom_sheet_body_widget_test.dart).
    final elementos = <DropdownBottomSheetElement<dynamic>>[
      DropdownBottomSheetElement<dynamic>(text: 'Um', value: 'a'),
      DropdownBottomSheetElement<dynamic>(text: 'Dois', value: 'b'),
    ];

    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => DropdownBottomSheet.show<dynamic>(
            context: context,
            title: 'Escolha',
            dropDownElements: elementos,
            doneFunction: (e) => escolhido = e,
            showFilter: false,
          ),
          child: const Text('abrir'),
        ),
      ),
    );

    expect(find.byType(BottomSheet), findsNothing);
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    final corpo = tester.widget<DropdownBottomSheetBodyWidget<dynamic>>(
      find.byType(DropdownBottomSheetBodyWidget<dynamic>),
    );
    expect(corpo.title, 'Escolha');
    expect(corpo.dropDownElements, same(elementos));
    expect(corpo.showFilter, isFalse);
    expect(find.text('Escolha'), findsOneWidget);

    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();
    expect(escolhido?.value, 'a');
    expect(find.byType(BottomSheet), findsNothing);
  });
}
