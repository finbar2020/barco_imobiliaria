import 'package:essentials/ui/widget/list/list_item/subtitle_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('constrói texto de subtítulo em negrito sem subtítulo',
      (tester) async {
    final item = SubtitleItem(text: 'Seção');
    expect(item.shouldWrapContent, isTrue);
    await pumpApp(
      tester,
      Builder(builder: (context) {
        expect(item.buildSubtitle(context), isNull);
        return item.buildTitle(context);
      }),
    );
    final texto = tester.widget<Text>(find.text('Seção'));
    expect(texto.style!.fontWeight, FontWeight.bold);
    expect(texto.style!.fontSize, 16);
  });
}
