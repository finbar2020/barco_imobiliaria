import 'package:essentials/ui/widget/list/list_builder.dart';
import 'package:essentials/ui/widget/list/list_item/button_primary_item.dart';
import 'package:essentials/ui/widget/list/list_item/form_display_item.dart';
import 'package:essentials/ui/widget/list/list_item/list_item.dart';
import 'package:essentials/ui/widget/list/list_item/row_item.dart';
import 'package:essentials/ui/widget/list/list_item/separator_item.dart';
import 'package:essentials/ui/widget/list/list_item/subtitle_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

class _ItemSemWrap implements ListItem {
  @override
  bool? shouldWrapContent;

  @override
  Widget buildTitle(BuildContext context) => const Text('sem wrap');

  @override
  Widget? buildSubtitle(BuildContext context) => null;
}

void main() {
  tearDown(resetPalletes);

  testWidgets('itens com wrap viram ListTile e os demais vão direto',
      (tester) async {
    var pressed = 0;
    final lista = ListBuilder.build([
      SubtitleItem(text: 'Seção'),
      FormDisplayItem(title: 'Nome', text: 'Maria'),
      SeparatorItem(),
      RowItem(children: const [Text('linha 1'), Text('linha 2')]),
      ButtonPrimaryItem(text: 'Salvar', onPressed: () => pressed++),
    ]);
    await pumpApp(tester, lista, shrinkWrap: false);

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.text('Seção'), findsOneWidget);
    expect(find.text('Nome'), findsOneWidget);
    expect(find.text('Maria'), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
    expect(find.text('linha 1'), findsOneWidget);
    expect(find.text('linha 2'), findsOneWidget);
    await tester.tap(find.text('Salvar'));
    expect(pressed, 1);

    final tile = tester.widget<ListTile>(find.byType(ListTile).first);
    expect(tile.contentPadding,
        const EdgeInsets.symmetric(horizontal: 24, vertical: 0));
    expect(
        find.ancestor(
            of: find.byType(Divider), matching: find.byType(ListTile)),
        findsNothing);
  });

  testWidgets('shrinkWrap e physics são repassados', (tester) async {
    final lista = ListBuilder.build(
      [SubtitleItem(text: 'x')],
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
    expect(lista.shrinkWrap, isTrue);
    expect(lista.physics, isA<NeverScrollableScrollPhysics>());
    await pumpApp(tester, lista, shrinkWrap: false);
    expect(find.text('x'), findsOneWidget);

    final padrao = ListBuilder.build([]);
    expect(padrao.shrinkWrap, isFalse);
    // Sem physics informado o ListView assume a física padrão (primary).
    expect(padrao.physics, isA<AlwaysScrollableScrollPhysics>());
  });

  testWidgets('lista vazia não renderiza itens', (tester) async {
    await pumpApp(tester, ListBuilder.build([]), shrinkWrap: false);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('item com shouldWrapContent nulo é tratado como false',
      (tester) async {
    /// Corrigido: `shouldWrapContent` nulo é tratado como `false` — o item é
    /// renderizado pelo próprio `buildTitle`, sem `ListTile` e sem erro.
    await pumpApp(tester, ListBuilder.build([_ItemSemWrap()]),
        shrinkWrap: false);
    expect(tester.takeException(), isNull);
    expect(find.text('sem wrap'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('golden da lista', (tester) async {
    await pumpApp(
      tester,
      ListBuilder.build([
        SubtitleItem(text: 'Dados'),
        FormDisplayItem(title: 'Nome', text: 'Maria'),
        SeparatorItem(height: 8),
        RowItem(children: const [Icon(Icons.person), Text(' Linha')]),
        ButtonPrimaryItem(text: 'Salvar', onPressed: () {}),
      ]),
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/list_builder.png'));
  });
}
