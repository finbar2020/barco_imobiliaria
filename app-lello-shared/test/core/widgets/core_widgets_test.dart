import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/color_palette_widget.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/half_color_icon.dart';
import 'package:shared_features/core/widgets/loading_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('traduz o título, centraliza e expõe as ações', (tester) async {
      var pressed = 0;
      await pumpApp(
        tester,
        Scaffold(
          appBar: CustomAppBar(
            title: 'minha_tela',
            actions: [
              IconButton(
                key: const Key('acao'),
                icon: const Icon(Icons.more_vert),
                onPressed: () => pressed++,
              ),
            ],
          ),
          body: const SizedBox(),
        ),
        wrapInScaffold: false,
        shrinkWrap: false,
        surface: const Size(400, 200),
      );
      expect(find.text('minha_tela'), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
      expect(appBar.backgroundColor, isNull);
      expect(appBar.shape, isA<RoundedRectangleBorder>());
      final title = tester.widget<Text>(find.text('minha_tela'));
      expect(title.style?.color, LelloTheme.palleteOf(LelloTheme.light).customColor());
      await tester.tap(find.byKey(const Key('acao')));
      await tester.pump();
      expect(pressed, 1);
      expect(const CustomAppBar(title: 'x').preferredSize, const Size.fromHeight(60));
      await expectLater(
          findGoldenSurface(), matchesGoldenFile('goldens/custom_app_bar.png'));
    });

    testWidgets('aceita cor de fundo e surfaceTint', (tester) async {
      await pumpApp(
        tester,
        const Scaffold(
          appBar: CustomAppBar(
            title: 'tela',
            backgroundColor: Colors.red,
            surfaceTintColor: Colors.blue,
          ),
        ),
        wrapInScaffold: false,
        shrinkWrap: false,
        surface: const Size(400, 200),
      );
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.red);
      expect(appBar.surfaceTintColor, Colors.blue);
      expect(appBar.actions, isNull);
    });
  });

  group('LoadingWidget', () {
    testWidgets('mostra progresso e o texto de espera', (tester) async {
      await pumpApp(tester, const LoadingWidget(), settle: false);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('please_wait'), findsOneWidget);
      await expectLater(
          findGoldenSurface(), matchesGoldenFile('goldens/loading_widget.png'));
    });
  });

  group('LoadingMessageWidget', () {
    testWidgets('sem mensagem mostra só o texto de espera', (tester) async {
      await pumpApp(tester, const LoadingMessageWidget(), settle: false);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('please_wait'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('mensagem vazia é ignorada', (tester) async {
      await pumpApp(tester, const LoadingMessageWidget(message: ''),
          settle: false);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('com mensagem mostra a mensagem em negrito acima', (tester) async {
      await pumpApp(tester, const LoadingMessageWidget(message: 'Enviando'),
          settle: false);
      expect(find.text('Enviando'), findsOneWidget);
      expect(find.text('please_wait'), findsOneWidget);
      final msg = tester.widget<Text>(find.text('Enviando'));
      expect(msg.style?.fontWeight, LelloTextStyles.bodyBold(LelloTheme.light)?.fontWeight);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/loading_message_widget.png'));
    });
  });

  group('ErrorMessageWidget', () {
    testWidgets('centraliza a mensagem', (tester) async {
      await pumpApp(tester, const ErrorMessageWidget(message: 'Algo deu errado'),
          shrinkWrap: false, surface: const Size(400, 300));
      expect(find.text('Algo deu errado'), findsOneWidget);
      final text = tester.widget<Text>(find.text('Algo deu errado'));
      expect(text.textAlign, TextAlign.center);
      expect(find.byType(Center), findsOneWidget);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/error_message_widget.png'));
    });
  });

  group('HalfColorIcon', () {
    testWidgets('desenha as duas metades com as cores e o tamanho', (tester) async {
      await pumpApp(
          tester,
          const HalfColorIcon(color1: Colors.red, color2: Colors.blue, size: 40));
      final containers =
          tester.widgetList<Container>(find.byType(Container)).toList();
      expect(containers, hasLength(2));
      expect((containers[0].decoration as BoxDecoration).color, Colors.red);
      expect((containers[1].decoration as BoxDecoration).color, Colors.blue);
      expect(tester.getSize(find.byType(Container).first), const Size(40, 40));
      final aligns = tester
          .widgetList<Align>(find.descendant(
              of: find.byType(ClipRect), matching: find.byType(Align)))
          .toList();
      expect(aligns.map((a) => a.widthFactor), [0.5, 0.5]);
      expect(aligns.map((a) => a.alignment),
          [Alignment.centerLeft, Alignment.centerRight]);
      const icon = HalfColorIcon(color1: Colors.red, color2: Colors.blue);
      expect(icon.size, 50.0);
      expect(icon.icon, Icons.circle);
      await expectLater(
          findGoldenSurface(), matchesGoldenFile('goldens/half_color_icon.png'));
    });
  });

  group('ColorPaletteWidget', () {
    testWidgets('lista todas as cores da paleta com o hexadecimal', (tester) async {
      await pumpApp(
        tester,
        ColorPaletteWidget(colorPalette: LightPallete()),
        wrapInScaffold: false,
        shrinkWrap: false,
        surface: const Size(500, 2400),
      );
      expect(find.text('Color Palette'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(28));
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('AppBar'), findsOneWidget);
      final primary = LightPallete().primary();
      final hex =
          '#${primary.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
      expect(find.text(hex), findsWidgets);
      final icon = tester.widget<Icon>(find.byType(Icon).first);
      expect(icon.color, primary);
      expect(icon.size, 24);
    });

    testWidgets('funciona com a paleta escura', (tester) async {
      await pumpApp(
        tester,
        ColorPaletteWidget(colorPalette: DarkPallete()),
        wrapInScaffold: false,
        shrinkWrap: false,
        dark: true,
        surface: const Size(400, 800),
      );
      expect(find.text('Color Palette'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/color_palette_widget_dark.png'));
    });
  });
}
