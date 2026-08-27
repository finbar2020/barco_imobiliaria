import 'package:essentials/ui/widget/expansion_tile/custom_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Finder iconeSeta() => find.byIcon(Icons.expand_more);

  RotationTransition rotacao(WidgetTester tester) =>
      tester.widget<RotationTransition>(find.ancestor(
        of: iconeSeta(),
        matching: find.byType(RotationTransition),
      ));

  testWidgets('começa colapsado, expande ao tocar e avisa onExpansionChanged',
      (tester) async {
    final mudancas = <bool>[];
    await pumpApp(
      tester,
      CustomExpansionTile(
        title: const Text('Título'),
        onExpansionChanged: mudancas.add,
        children: const [Text('Filho 1'), Text('Filho 2')],
      ),
    );

    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Filho 1'), findsNothing,
        reason: 'fechado não constrói os filhos');
    expect(iconeSeta(), findsOneWidget);
    expect(rotacao(tester).turns.value, 0.0);

    await tester.tap(find.text('Título'));
    await tester.pump();
    expect(mudancas, [true]);
    await tester.pumpAndSettle();

    expect(find.text('Filho 1'), findsOneWidget);
    expect(find.text('Filho 2'), findsOneWidget);
    expect(rotacao(tester).turns.value, 0.5, reason: 'seta virada para cima');

    await tester.tap(find.text('Título'));
    await tester.pump();
    expect(mudancas, [true, false]);
    // Durante a animação de fechamento os filhos ainda existem.
    expect(find.text('Filho 1'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Filho 1'), findsNothing,
        reason: 'após fechar, reconstrói sem os filhos');
    expect(rotacao(tester).turns.value, 0.0);
  });

  testWidgets('initiallyExpanded mostra os filhos de imediato', (tester) async {
    await pumpApp(
      tester,
      CustomExpansionTile(
        title: const Text('Aberto'),
        initiallyExpanded: true,
        children: const [Text('Conteúdo')],
      ),
    );
    expect(find.text('Conteúdo'), findsOneWidget);
    expect(rotacao(tester).turns.value, 0.5);
  });

  testWidgets('leading, subtitle, trailing customizado e sem onExpansionChanged',
      (tester) async {
    await pumpApp(
      tester,
      CustomExpansionTile(
        title: const Text('Título'),
        subtitle: const Text('Subtítulo'),
        leading: const Icon(Icons.home),
        trailing: const Icon(Icons.add),
        iconColor: Colors.red,
        children: const [Text('Conteúdo')],
      ),
    );
    expect(find.text('Subtítulo'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(iconeSeta(), findsNothing);

    // Sem callback, tocar só expande.
    await tester.tap(find.text('Título'));
    await tester.pumpAndSettle();
    expect(find.text('Conteúdo'), findsOneWidget);
  });

  testWidgets('hideTrailing remove o ícone e iconColor colore a seta',
      (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          CustomExpansionTile(
            title: const Text('Sem seta'),
            hideTrailing: true,
            trailing: const Icon(Icons.add),
          ),
          CustomExpansionTile(
            title: const Text('Seta vermelha'),
            iconColor: Colors.red,
          ),
        ],
      ),
    );
    expect(find.byIcon(Icons.add), findsNothing,
        reason: 'hideTrailing vence o trailing informado');
    final seta = tester.widget<Icon>(iconeSeta());
    expect(seta.color, Colors.red);
  });

  testWidgets('showDivider controla a borda e as cores de fundo são aplicadas',
      (tester) async {
    await pumpApp(
      tester,
      Column(
        children: [
          CustomExpansionTile(
            key: const Key('com'),
            title: const Text('Com divisor'),
            initiallyExpanded: true,
            backgroundColor: Colors.amber,
            headerBackgroundColor: Colors.blue,
            children: const [Text('A')],
          ),
          CustomExpansionTile(
            key: const Key('sem'),
            title: const Text('Sem divisor'),
            showDivider: false,
            initiallyExpanded: true,
            children: const [Text('B')],
          ),
        ],
      ),
    );

    Container container(Key key) => tester.widget<Container>(find.descendant(
          of: find.byKey(key),
          matching: find.byType(Container),
        ).first);

    final com = container(const Key('com')).decoration as BoxDecoration;
    expect(com.color, Colors.amber, reason: 'expandido usa backgroundColor');
    expect(com.border, isA<Border>());
    expect((com.border as Border).top.color, isNot(Colors.transparent));
    expect((com.border as Border).left, BorderSide.none);

    final sem = container(const Key('sem')).decoration as BoxDecoration;
    expect((sem.border as Border).top.width, 0);
    expect((sem.border as Border).top.color, Colors.transparent);

    final material = tester.widget<Material>(find.descendant(
      of: find.byKey(const Key('com')),
      matching: find.byType(Material),
    ).first);
    expect(material.color, Colors.blue);
  });

  testWidgets('restaura o estado expandido pelo PageStorage', (tester) async {
    final bucket = PageStorageBucket();
    Widget build() => PageStorage(
          bucket: bucket,
          child: CustomExpansionTile(
            key: const PageStorageKey('tile'),
            title: const Text('Título'),
            children: const [Text('Conteúdo')],
          ),
        );

    await pumpApp(tester, build());
    expect(find.text('Conteúdo'), findsNothing);
    await tester.tap(find.text('Título'));
    await tester.pumpAndSettle();
    expect(find.text('Conteúdo'), findsOneWidget);

    // Desmonta e monta de novo com o mesmo bucket: continua expandido.
    await tester.pumpWidget(const SizedBox());
    await pumpApp(tester, build());
    expect(find.text('Conteúdo'), findsOneWidget);

    // Fecha e verifica que o bucket recebeu false.
    await tester.tap(find.text('Título'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await pumpApp(tester, build());
    expect(find.text('Conteúdo'), findsNothing);
  });

  testWidgets('desmontar durante a animação de fechamento não lança',
      (tester) async {
    await pumpApp(
      tester,
      CustomExpansionTile(
        title: const Text('Título'),
        initiallyExpanded: true,
        children: const [Text('Conteúdo')],
      ),
    );
    await tester.tap(find.text('Título'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: colapsado e expandido', (tester) async {
    Widget build({required bool aberto}) => CustomExpansionTile(
          title: const Text('Detalhes do condomínio'),
          subtitle: const Text('Toque para ver mais'),
          leading: const Icon(Icons.apartment),
          initiallyExpanded: aberto,
          children: const [
            ListTile(title: Text('Unidade 101')),
            ListTile(title: Text('Unidade 102')),
          ],
        );

    await pumpApp(tester, build(aberto: false));
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/custom_expansion_tile_colapsado.png'),
    );

    await pumpApp(tester, build(aberto: true));
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/custom_expansion_tile_expandido.png'),
    );
  });
}
