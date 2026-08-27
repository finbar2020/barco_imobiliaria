import 'package:essentials/ui/widget/list/list_item/separator_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('constrói um Divider com a altura informada', (tester) async {
    final padrao = SeparatorItem();
    final alto = SeparatorItem(height: 12);
    expect(padrao.shouldWrapContent, isFalse);
    expect(padrao.height, 1.0);
    await pumpApp(
      tester,
      Builder(builder: (context) {
        expect(alto.buildSubtitle(context), isNull);
        return Column(children: [
          padrao.buildTitle(context),
          alto.buildTitle(context),
        ]);
      }),
    );
    final dividers = tester.widgetList<Divider>(find.byType(Divider)).toList();
    expect(dividers[0].height, 1.0);
    expect(dividers[1].height, 12.0);
  });
}
