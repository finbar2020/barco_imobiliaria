import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/colors/carimbeira_pallete.dart';
import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import 'ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  group('themeWithPallete', () {
    test('tema claro usa a paleta clara', () {
      final theme = LelloTheme.light;
      final p = LightPallete();
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
      expect(theme.primaryColor, p.primary());
      expect(theme.colorScheme.primary, p.primary());
      expect(theme.colorScheme.secondary, p.accent());
      expect(theme.colorScheme.shadow, p.hubText());
      expect(theme.colorScheme.tertiary, p.raffle());
      expect(theme.colorScheme.surface, Colors.white);
      expect(theme.colorScheme.onSurface, p.text());
      expect(theme.colorScheme.outline, p.separator());
      expect(theme.colorScheme.secondaryContainer, p.primary());
      expect(theme.secondaryHeaderColor, p.secondary());
      expect(theme.scaffoldBackgroundColor, p.background());
      expect(theme.canvasColor, p.background());
      expect(theme.cardColor, p.background());
      expect(theme.bottomNavigationBarTheme.backgroundColor, p.background());
      expect(theme.dialogTheme.backgroundColor, p.background());
      expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
      expect(theme.inputDecorationTheme.hintStyle?.color, p.textOpaque());
      // ignore: deprecated_member_use
      expect(theme.splashColor, p.primary().withOpacity(0.2));
      // ignore: deprecated_member_use
      expect(theme.highlightColor, p.primary().withOpacity(0.1));
      expect(theme.chipTheme.showCheckmark, isFalse);
    });

    test('divider, checkbox, botão, texto e app bar vêm da paleta', () {
      final theme = LelloTheme.light;
      final p = LightPallete();
      expect(theme.dividerTheme.color, p.separator());
      expect(theme.dividerTheme.thickness, 1);
      expect(theme.dividerTheme.space, 0);

      expect(theme.checkboxTheme.side, BorderSide(color: p.grey(), width: 2));
      expect(theme.checkboxTheme.fillColor!.resolve({WidgetState.selected}),
          p.secondary());
      expect(theme.checkboxTheme.fillColor!.resolve({}), isNull);
      expect(theme.checkboxTheme.checkColor!.resolve({}), Colors.white);

      expect(theme.buttonTheme.height, 48.0);
      expect(theme.buttonTheme.textTheme, ButtonTextTheme.normal);
      expect(theme.textTheme.bodyMedium?.color, p.text());
      expect(theme.appBarTheme.backgroundColor, p.appBar());
    });

    test('tema escuro usa a paleta escura', () {
      final theme = LelloTheme.dark;
      final p = DarkPallete();
      expect(theme.brightness, Brightness.dark);
      expect(theme.primaryColor, p.primary());
      expect(theme.scaffoldBackgroundColor, const Color(0xFF000000));
      expect(theme.textTheme.bodyMedium?.color, const Color(0xFFFFFFFF));
      expect(theme.colorScheme.outline, p.separator());
    });

    test('tema carimbeira usa a paleta carimbeira', () {
      final theme = LelloTheme.carimbeira;
      expect(theme.brightness, Brightness.light);
      expect(theme.primaryColor, carimbeiraPrimaryDefault);
      expect(theme.secondaryHeaderColor, carimbeiraSecondaryDefault);
      expect(theme.colorScheme.secondary, carimbeiraSecondaryDefault);
    });

    test('temas estáticos são instâncias únicas', () {
      expect(identical(LelloTheme.light, LelloTheme.light), isTrue);
      expect(identical(LelloTheme.dark, LelloTheme.dark), isTrue);
      expect(identical(LelloTheme.carimbeira, LelloTheme.carimbeira), isTrue);
    });
  });

  group('palleteOf', () {
    test('devolve a paleta pelo brilho do tema', () {
      expect(LelloTheme.palleteOf(LelloTheme.light), isA<LightPallete>());
      expect(LelloTheme.palleteOf(LelloTheme.dark), isA<DarkPallete>());
      expect(LelloTheme.palleteOf(ThemeData.light()), isA<LightPallete>());
      expect(LelloTheme.palleteOf(ThemeData.dark()), isA<DarkPallete>());
    });

    test('reconhece o tema carimbeira pela cor primária', () {
      expect(LelloTheme.palleteOf(LelloTheme.carimbeira),
          isA<CarimbeiraPallete>());
      expect(
          LelloTheme.palleteOf(
              ThemeData(primaryColor: carimbeiraPrimaryDefault)),
          isA<CarimbeiraPallete>());
    });

    test('tema escuro com a cor primária da carimbeira vira escuro', () {
      /// Corrigido: sem paleta registrada no tema, o brilho decide primeiro;
      /// a carimbeira só é reconhecida pela cor primária em temas claros.
      final theme = ThemeData(
          brightness: Brightness.dark, primaryColor: carimbeiraPrimaryDefault);
      expect(LelloTheme.palleteOf(theme), isA<DarkPallete>());
    });

    test('tema criado com uma paleta customizada devolve essa paleta', () {
      /// Corrigido: `themeWithPallete` registra a paleta no tema, então
      /// `palleteOf` devolve a própria instância (inclusive customizada, e
      /// após `copyWith`) sem mexer no singleton.
      final custom = LightPallete(primary: Colors.teal, secondary: Colors.lime);
      final theme = LelloTheme.themeWithPallete(Brightness.light, custom);
      expect(LelloTheme.palleteOf(theme), same(custom));
      expect(LelloTheme.palleteOf(theme.copyWith(cardColor: Colors.red)),
          same(custom));
      expect(LelloTheme.palleteOf(theme).primary(), Colors.teal);
      expect(LightPallete().primary(), lightPrimaryDefault);

      final dark = LelloTheme.themeWithPallete(
          Brightness.dark, DarkPallete(primary: Colors.teal));
      expect(LelloTheme.palleteOf(dark).primary(), Colors.teal);
      expect(DarkPallete().primary(), darkPrimaryDefault);
    });

    test('paleta registrada sobrevive a lerp e copyWith da extensão', () {
      // `AnimatedTheme` interpola temas: antes da metade fica a paleta de
      // origem, depois a de destino.
      final meio = ThemeData.lerp(LelloTheme.light, LelloTheme.dark, 0.3);
      expect(LelloTheme.palleteOf(meio), isA<LightPallete>());
      final fim = ThemeData.lerp(LelloTheme.light, LelloTheme.dark, 0.7);
      expect(LelloTheme.palleteOf(fim), isA<DarkPallete>());
      // Tema sem a extensão do outro lado mantém a própria paleta.
      final semExt =
          ThemeData.lerp(LelloTheme.carimbeira, ThemeData.dark(), 0.9);
      expect(LelloTheme.palleteOf(semExt), isA<CarimbeiraPallete>());

      final extensao = LelloTheme.carimbeira.extensions.values.single;
      final copiado = ThemeData(extensions: [extensao.copyWith()]);
      expect(LelloTheme.palleteOf(copiado), isA<CarimbeiraPallete>());
    });
  });

  group('temas padrão', () {
    test('viverDefaultTheme usa preto como primary e secondary', () {
      final theme = LelloTheme.viverDefaultTheme;
      expect(theme.primaryColor, Colors.black);
      expect(theme.secondaryHeaderColor, Colors.black);
      expect(theme.brightness, Brightness.light);
    });

    test('lelloDefaultTheme reflete a paleta clara atual', () {
      resetPalletes();
      final theme = LelloTheme.lelloDefaultTheme;
      expect(theme.primaryColor, lightPrimaryDefault);
      expect(theme.secondaryHeaderColor, lightSecondaryDefault);
    });

    test('viverDefaultTheme customiza o singleton e lelloDefaultTheme restaura',
        () {
      resetPalletes();
      final viver = LelloTheme.viverDefaultTheme;

      /// Corrigido: `viverDefaultTheme` continua aplicando preto no singleton
      /// `LightPallete` (efeito global esperado pelos apps viver), mas
      /// `lelloDefaultTheme` agora restaura explicitamente o vermelho Lello.
      expect(LightPallete().primary(), Colors.black);
      expect(LightPallete().secondary(), Colors.black);
      expect(LelloTheme.palleteOf(viver), isA<LightPallete>());
      expect(LelloTheme.palleteOf(viver).primary(), Colors.black);

      final lello = LelloTheme.lelloDefaultTheme;
      expect(lello.primaryColor, lightPrimaryDefault);
      expect(lello.secondaryHeaderColor, lightSecondaryDefault);
      expect(LightPallete().primary(), lightPrimaryDefault);
      expect(LightPallete().secondary(), lightSecondaryDefault);
      expect(LelloTheme.palleteOf(lello).primary(), lightPrimaryDefault);
    });
  });

  testWidgets('golden: componentes básicos com o tema claro', (tester) async {
    await pumpApp(
      tester,
      Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Título', style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            Row(children: [
              Checkbox(value: true, onChanged: (_) {}),
              Checkbox(value: false, onChanged: (_) {}),
              const Chip(label: Text('chip')),
            ]),
            const TextField(decoration: InputDecoration(hintText: 'dica')),
          ],
        );
      }),
      surface: const Size(400, 300),
    );
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('goldens/app_theme_light.png'));
  });

  testWidgets('golden: componentes básicos com o tema escuro', (tester) async {
    await pumpApp(
      tester,
      Material(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Título'),
            const Divider(),
            Row(children: [
              Checkbox(value: true, onChanged: (_) {}),
              Checkbox(value: false, onChanged: (_) {}),
            ]),
          ],
        ),
      ),
      dark: true,
      surface: const Size(400, 200),
    );
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('goldens/app_theme_dark.png'));
  });
}
