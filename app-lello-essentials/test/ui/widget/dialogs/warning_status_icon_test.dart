import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/widget/dialogs/warning_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('padrão desenha a exclamação fina (haste + ponto) em branco',
      (tester) async {
    await pumpApp(tester, const Center(child: WarningStatusIcon()));

    final externo = tester.widget<Container>(find.byType(Container).first);
    final decoracao = externo.decoration as BoxDecoration;
    expect(decoracao.shape, BoxShape.circle);
    expect(decoracao.color, LelloTheme.palleteOf(readableTheme()).warning());
    expect(tester.getSize(find.byType(WarningStatusIcon)), const Size(48, 48));

    // Sem Icon: a exclamação é composta por dois containers.
    expect(find.byType(Icon), findsNothing);
    expect(find.byType(Container), findsNWidgets(3));

    final partes = tester
        .widgetList<Container>(find.byType(Container))
        .skip(1)
        .toList();
    final haste = partes[0].decoration as BoxDecoration;
    final ponto = partes[1].decoration as BoxDecoration;
    expect(haste.color, Colors.white);
    expect(ponto.color, Colors.white);
    expect(ponto.shape, BoxShape.circle);

    final tamanhos = find.byType(Container).evaluate().skip(1).map(
          (e) => (e.renderObject as RenderBox).size,
        );
    expect(tamanhos.first, const Size(36 * 0.14, 36 * 0.56));
    expect(tamanhos.last, const Size(36 * 0.16, 36 * 0.16));
  });

  testWidgets('com outro ícone usa Icon normal e respeita cores e margem',
      (tester) async {
    await pumpApp(
      tester,
      const Center(
        child: WarningStatusIcon(
          size: 60,
          iconSize: 24,
          icon: Icons.info,
          iconColor: Colors.black,
          backgroundColor: Colors.orange,
          margin: EdgeInsets.symmetric(horizontal: 4),
        ),
      ),
    );

    final externo = tester.widget<Container>(find.byType(Container).first);
    expect((externo.decoration as BoxDecoration).color, Colors.orange);
    expect(externo.margin, const EdgeInsets.symmetric(horizontal: 4));
    final icone = tester.widget<Icon>(find.byIcon(Icons.info));
    expect(icone.color, Colors.black);
    expect(icone.size, 24);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('iconColor customizado pinta a exclamação fina', (tester) async {
    await pumpApp(
      tester,
      const Center(child: WarningStatusIcon(iconColor: Colors.red)),
    );
    final partes = tester
        .widgetList<Container>(find.byType(Container))
        .skip(1)
        .map((c) => (c.decoration as BoxDecoration).color);
    expect(partes, everyElement(Colors.red));
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WarningStatusIcon(),
          WarningStatusIcon(size: 72, iconSize: 48),
          WarningStatusIcon(icon: Icons.info_outline),
        ],
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/warning_status_icon.png'),
    );
  });
}
