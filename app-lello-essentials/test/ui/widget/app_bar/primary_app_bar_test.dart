import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/app_bar/primary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  Widget tela({
    List<Widget>? actions,
    bool centerTitle = true,
    Color? iconColor,
    Widget? leading,
    PreferredSizeWidget? tabs,
    VoidCallback? onBack,
  }) =>
      Builder(
        builder: (context) => Scaffold(
          appBar: PrimaryAppBar(
            title: 'Título',
            theme: Theme.of(context),
            actions: actions,
            centerTitle: centerTitle,
            iconColor: iconColor,
            leading: leading,
            tabs: tabs,
            onBackArrowPressed: onBack,
          ),
          body: const Text('corpo'),
        ),
      );

  testWidgets('na raiz não mostra seta de voltar', (tester) async {
    await pumpApp(tester, tela(), wrapInScaffold: false, shrinkWrap: false);
    expect(find.text('Título'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, LightPallete().appBar());
    expect(appBar.centerTitle, isTrue);
    expect(appBar.surfaceTintColor, Colors.transparent);
    expect(appBar.iconTheme!.color, LelloTheme.light.colorScheme.surface);
    final shape = appBar.shape as RoundedRectangleBorder;
    expect(shape.borderRadius,
        const BorderRadius.vertical(bottom: Radius.circular(8)));
    final titulo = tester.widget<Text>(find.text('Título'));
    expect(titulo.style!.color, Colors.white);
    expect(titulo.style!.fontWeight, FontWeight.bold);
    expect(titulo.textAlign, TextAlign.center);
  });

  testWidgets('em rota empilhada mostra a seta e volta ao tocar',
      (tester) async {
    final observer = RecordingNavigatorObserver();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.pushNamed(context, '/detalhe'),
          child: const Text('abrir'),
        ),
      ),
      routes: {'/detalhe': (_) => tela()},
      navigatorObserver: observer,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    final icone = tester.widget<Icon>(find.byIcon(Icons.arrow_back));
    expect(icone.color, LightPallete().primary());

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(observer.popped.length, 1);
    expect(find.text('abrir'), findsOneWidget);
  });

  testWidgets('onBackArrowPressed substitui o pop e iconColor pinta a seta',
      (tester) async {
    var voltou = 0;
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.pushNamed(context, '/detalhe'),
          child: const Text('abrir'),
        ),
      ),
      routes: {
        '/detalhe': (_) =>
            tela(onBack: () => voltou++, iconColor: Colors.green),
      },
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(tester.widget<Icon>(find.byIcon(Icons.arrow_back)).color,
        Colors.green);
    expect(tester.widget<AppBar>(find.byType(AppBar)).iconTheme!.color,
        Colors.green);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(voltou, 1);
    expect(find.text('corpo'), findsOneWidget);
  });

  testWidgets('leading, actions, tabs e centerTitle customizados',
      (tester) async {
    await pumpApp(
      tester,
      DefaultTabController(
        length: 2,
        child: tela(
          leading: const Icon(Icons.menu, key: Key('menu')),
          actions: const [Icon(Icons.search, key: Key('busca'))],
          centerTitle: false,
          tabs: const TabBar(tabs: [Tab(text: 'A'), Tab(text: 'B')]),
        ),
      ),
      wrapInScaffold: false,
      shrinkWrap: false,
    );
    expect(find.byKey(const Key('menu')), findsOneWidget);
    expect(find.byKey(const Key('busca')), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(tester.widget<AppBar>(find.byType(AppBar)).centerTitle, isFalse);
  });

  testWidgets('no tema escuro usa a cor da paleta escura', (tester) async {
    await pumpApp(tester, tela(),
        wrapInScaffold: false, shrinkWrap: false, dark: true);
    expect(tester.widget<AppBar>(find.byType(AppBar)).backgroundColor,
        DarkPallete().appBar());
  });

  testWidgets('golden da app bar com seta de voltar', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.pushNamed(context, '/detalhe'),
          child: const Text('abrir'),
        ),
      ),
      routes: {
        '/detalhe': (_) => RepaintBoundary(
              key: const Key('appbar-golden'),
              child: tela(actions: const [Icon(Icons.more_vert)]),
            ),
      },
      surface: const Size(400, 200),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await expectLater(find.byKey(const Key('appbar-golden')),
        matchesGoldenFile('../../goldens/primary_app_bar.png'));
  });
}
