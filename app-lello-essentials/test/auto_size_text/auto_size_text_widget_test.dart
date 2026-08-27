import 'package:auto_size_text/auto_size_text.dart';
import 'package:essentials/auto_size_text/auto_size_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('renderiza texto centralizado com estilo e maxLines',
      (tester) async {
    await pumpApp(
      tester,
      const AutoSizeTextWidget(
        text: 'Olá',
        style: TextStyle(fontSize: 20, color: Colors.red),
        maxLines: 2,
      ),
      shrinkWrap: false,
    );
    final auto = tester.widget<AutoSizeText>(find.byType(AutoSizeText));
    expect(auto.data, 'Olá');
    expect(auto.style!.color, Colors.red);
    expect(auto.maxLines, 2);
    expect(auto.overflow, isNull);
    expect(auto.textAlign, TextAlign.center);
    expect(auto.overflowReplacement, isA<FittedBox>());
    expect(find.text('Olá'), findsOneWidget);
    expect(find.byType(FittedBox), findsNothing);
  });

  testWidgets('sem overflow usa FittedBox quando o texto não cabe',
      (tester) async {
    await pumpApp(
      tester,
      const Center(
        child: SizedBox(
          width: 60,
          child: AutoSizeTextWidget(
            text: 'Texto muito comprido que não cabe',
            maxLines: 1,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      shrinkWrap: false,
    );
    expect(find.byType(FittedBox), findsOneWidget);
    expect(find.text('Texto muito comprido que não cabe'), findsOneWidget);
  });

  testWidgets('com overflow informado não há substituto', (tester) async {
    await pumpApp(
      tester,
      const Center(
        child: SizedBox(
          width: 60,
          child: AutoSizeTextWidget(
            text: 'Texto muito comprido que não cabe',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      shrinkWrap: false,
    );
    final auto = tester.widget<AutoSizeText>(find.byType(AutoSizeText));
    expect(auto.overflow, TextOverflow.ellipsis);
    expect(auto.overflowReplacement, isNull);
    expect(find.byType(FittedBox), findsNothing);
  });

  testWidgets('golden do texto auto ajustável', (tester) async {
    await pumpApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          AutoSizeTextWidget(text: 'Cabe na linha', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          SizedBox(
            width: 120,
            child: AutoSizeTextWidget(
              text: 'Texto comprido reduzido pelo FittedBox',
              maxLines: 1,
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 120,
            child: AutoSizeTextWidget(
              text: 'Texto comprido com reticências',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      surface: const Size(400, 200),
      shrinkWrap: false,
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../ui/goldens/auto_size_text_widget.png'));
  });
}
