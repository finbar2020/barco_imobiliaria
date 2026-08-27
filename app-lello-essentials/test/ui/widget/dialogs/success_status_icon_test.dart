import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/widget/dialogs/success_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('padrão: círculo na cor de sucesso com check branco',
      (tester) async {
    await pumpApp(tester, const Center(child: SuccessStatusIcon()));

    final container = tester.widget<Container>(find.byType(Container));
    final decoracao = container.decoration as BoxDecoration;
    expect(decoracao.shape, BoxShape.circle);
    expect(decoracao.color, LelloTheme.palleteOf(readableTheme()).success());
    expect(container.margin, isNull);
    expect(tester.getSize(find.byType(SuccessStatusIcon)), const Size(48, 48));

    final icone = tester.widget<Icon>(find.byIcon(Icons.check_rounded));
    expect(icone.color, Colors.white);
    expect(icone.size, 36);
  });

  testWidgets('aceita tamanho, cores, ícone e margem customizados',
      (tester) async {
    await pumpApp(
      tester,
      const Center(
        child: SuccessStatusIcon(
          size: 64,
          iconSize: 20,
          backgroundColor: Colors.teal,
          iconColor: Colors.black,
          icon: Icons.thumb_up,
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    expect((container.decoration as BoxDecoration).color, Colors.teal);
    expect(container.margin, const EdgeInsets.only(top: 10));
    expect(tester.getSize(find.byType(SuccessStatusIcon)), const Size(64, 74));
    final icone = tester.widget<Icon>(find.byIcon(Icons.thumb_up));
    expect(icone.color, Colors.black);
    expect(icone.size, 20);
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SuccessStatusIcon(),
          SuccessStatusIcon(size: 72, iconSize: 48, iconColor: Colors.black),
        ],
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/success_status_icon.png'),
    );
  });
}
