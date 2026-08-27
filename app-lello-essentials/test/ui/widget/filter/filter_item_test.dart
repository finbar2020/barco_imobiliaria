import 'package:essentials/ui/widget/filter/filter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  testWidgets('mostra título e conteúdo traduzidos e chama onTap no X',
      (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      Align(
        alignment: Alignment.centerLeft,
        child: FilterItem(
          title: 'status',
          content: 'active',
          onTap: () => taps++,
        ),
      ),
      locOverrides: {'status': 'Status', 'active': 'Ativo'},
    );
    final rich = tester.widget<RichText>(find.byType(RichText).first);
    expect(rich.text.toPlainText(), 'Status: Ativo');
    final spans = (rich.text as TextSpan).children!.cast<TextSpan>();
    expect(spans.length, 3);
    expect(spans[2].style!.fontWeight, FontWeight.bold);

    await tester.tap(find.byIcon(Icons.close));
    expect(taps, 1);
    expect(tester.widget<Icon>(find.byIcon(Icons.close)).size, 15);
  });

  testWidgets('sem conteúdo mostra só o título', (tester) async {
    await pumpApp(
      tester,
      Align(
        alignment: Alignment.centerLeft,
        child: FilterItem(title: 'status', content: null, onTap: () {}),
      ),
    );
    final rich = tester.widget<RichText>(find.byType(RichText).first);
    expect(rich.text.toPlainText(), 'status');
    expect((rich.text as TextSpan).children!.length, 1);
  });

  testWidgets('conteúdo sem tradução é exibido literalmente', (tester) async {
    await pumpApp(
      tester,
      Align(
        alignment: Alignment.centerLeft,
        child: FilterItem(title: 'status', content: 'Bloco A', onTap: () {}),
      ),
      locOverrides: {'Bloco A': ''},
    );
    final rich = tester.widget<RichText>(find.byType(RichText).first);
    expect(rich.text.toPlainText(), 'status: Bloco A');
  });

  testWidgets('decoração arredondada cinza e estilo do tema em contexto',
      (tester) async {
    await pumpApp(
      tester,
      Align(
        alignment: Alignment.centerLeft,
        child: FilterItem(title: 't', content: 'c', onTap: () {}),
      ),
      dark: true,
    );
    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.grey[300]);
    expect(decoration.borderRadius, BorderRadius.circular(20));

    /// Corrigido: o estilo do texto vem de `Theme.of(context)`, então no tema
    /// escuro o texto usa a cor de texto da paleta escura (branco).
    final rich = tester.widget<RichText>(find.byType(RichText).first);
    final spans = (rich.text as TextSpan).children!.cast<TextSpan>();
    expect(spans[0].style!.color, const Color(0xFFFFFFFF));
    expect(spans[1].style!.color, const Color(0xFFFFFFFF));
    expect(spans[2].style!.color, const Color(0xFFFFFFFF));
  });

  testWidgets('golden do filtro', (tester) async {
    await pumpApp(
      tester,
      Wrap(
        spacing: 8,
        children: [
          FilterItem(title: 'Status', content: 'Ativo', onTap: () {}),
          FilterItem(title: 'Somente título', content: null, onTap: () {}),
        ],
      ),
      surface: const Size(400, 120),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/filter_item.png'));
  });
}
