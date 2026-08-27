import 'package:essentials/ui/widget/list/list_item/form_display_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('título em negrito e texto normal', (tester) async {
    final item = FormDisplayItem(title: 'CPF', text: '123');
    expect(item.shouldWrapContent, isTrue);
    await pumpApp(
      tester,
      Builder(
        builder: (context) => Column(children: [
          item.buildTitle(context),
          item.buildSubtitle(context),
        ]),
      ),
    );
    expect(tester.widget<Text>(find.text('CPF')).style!.fontWeight,
        FontWeight.w700);
    expect(tester.widget<Text>(find.text('123')).style!.fontWeight,
        FontWeight.normal);
    expect(tester.widget<Text>(find.text('123')).style!.fontSize, 14);
  });
}
