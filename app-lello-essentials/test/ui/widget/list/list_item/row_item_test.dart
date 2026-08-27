import 'package:essentials/ui/widget/list/list_item/row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('constrói uma Row com os filhos e sem subtítulo', (tester) async {
    final item = RowItem(children: const [Text('a'), Text('b')]);
    expect(item.shouldWrapContent, isFalse);
    await pumpApp(
      tester,
      Builder(builder: (context) {
        expect(item.buildSubtitle(context), isNull);
        return item.buildTitle(context);
      }),
    );
    expect(find.byType(Row), findsOneWidget);
    expect(find.text('a'), findsOneWidget);
    expect(find.text('b'), findsOneWidget);
  });
}
