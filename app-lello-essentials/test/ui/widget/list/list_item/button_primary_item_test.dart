import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:essentials/ui/widget/list/list_item/button_primary_item.dart';
import 'package:essentials/ui/widget/list/list_item/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('constrói um PrimaryButton com o texto e sem subtítulo',
      (tester) async {
    var pressed = 0;
    final item = ButtonPrimaryItem(text: 'Enviar', onPressed: () => pressed++);
    expect(item, isA<ListItem>());
    expect(item.shouldWrapContent, isTrue);

    await pumpApp(
      tester,
      Builder(builder: (context) {
        expect(item.buildSubtitle(context), isNull);
        return item.buildTitle(context);
      }),
    );
    expect(find.byType(PrimaryButton), findsOneWidget);
    await tester.tap(find.text('Enviar'));
    expect(pressed, 1);
  });

  testWidgets('texto nulo renderiza botão vazio', (tester) async {
    final item = ButtonPrimaryItem(onPressed: () {});
    await pumpApp(tester, Builder(builder: item.buildTitle));
    expect(find.text(''), findsOneWidget);
  });
}
