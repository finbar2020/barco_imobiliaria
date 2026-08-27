import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/section/alt_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  testWidgets('padding padrão de 24 e fundo separador com cantos inferiores',
      (tester) async {
    await pumpApp(tester, const AltSection(child: Text('conteúdo')));
    expect(find.text('conteúdo'), findsOneWidget);
    final container = tester.widget<Container>(find.byType(Container));
    expect(container.padding, const EdgeInsets.all(24));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, LightPallete().separator());
    expect(decoration.borderRadius,
        const BorderRadius.vertical(bottom: Radius.circular(8)));
  });

  testWidgets('padding customizado e tema escuro', (tester) async {
    await pumpApp(
      tester,
      const AltSection(padding: EdgeInsets.all(4), child: Text('x')),
      dark: true,
    );
    final container = tester.widget<Container>(find.byType(Container));
    expect(container.padding, const EdgeInsets.all(4));
    expect((container.decoration as BoxDecoration).color,
        DarkPallete().separator());
  });

  testWidgets('golden da seção alternativa', (tester) async {
    await pumpApp(
      tester,
      const AltSection(child: Text('Seção alternativa')),
      surface: const Size(400, 120),
    );
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('../../goldens/alt_section.png'));
  });
}
