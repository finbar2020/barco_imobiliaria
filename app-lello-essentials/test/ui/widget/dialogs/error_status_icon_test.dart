import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/widget/dialogs/error_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('padrão: círculo na cor de erro com X branco de 36 dentro de 48',
      (tester) async {
    await pumpApp(tester, const Center(child: ErrorStatusIcon()));

    final container = tester.widget<Container>(find.byType(Container));
    final decoracao = container.decoration as BoxDecoration;
    expect(decoracao.shape, BoxShape.circle);
    expect(decoracao.color, LelloTheme.palleteOf(readableTheme()).error());
    expect(container.margin, isNull);
    expect(tester.getSize(find.byType(ErrorStatusIcon)), const Size(48, 48));

    final icone = tester.widget<Icon>(find.byIcon(Icons.close_rounded));
    expect(icone.color, Colors.white);
    expect(icone.size, 36);
  });

  testWidgets('aceita tamanho, cores, ícone e margem customizados',
      (tester) async {
    await pumpApp(
      tester,
      const Center(
        child: ErrorStatusIcon(
          size: 64,
          iconSize: 20,
          backgroundColor: Colors.purple,
          iconColor: Colors.yellow,
          icon: Icons.warning,
          margin: EdgeInsets.all(8),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    expect((container.decoration as BoxDecoration).color, Colors.purple);
    expect(container.margin, const EdgeInsets.all(8));
    expect(tester.getSize(find.byType(ErrorStatusIcon)), const Size(80, 80));
    final icone = tester.widget<Icon>(find.byIcon(Icons.warning));
    expect(icone.color, Colors.yellow);
    expect(icone.size, 20);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ErrorStatusIcon(),
          ErrorStatusIcon(size: 72, iconSize: 48, backgroundColor: Colors.black),
        ],
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/error_status_icon.png'),
    );
  });
}
