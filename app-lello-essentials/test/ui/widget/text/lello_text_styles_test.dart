import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  group('themeWith', () {
    test('tamanhos, pesos e alturas de linha', () {
      final TextTheme t = LelloTextStyles.themeWith(LightPallete());
      void check(TextStyle? s, double size, FontWeight w, double h) {
        expect(s, isNotNull);
        expect(s!.fontSize, size);
        expect(s.fontWeight, w);
        expect(s.height, h);
      }

      check(t.displayLarge, 36, FontWeight.w200, 1.2);
      check(t.displayMedium, 56, FontWeight.normal, 1.2);
      check(t.displaySmall, 45, FontWeight.normal, 1.2);
      check(t.headlineMedium, 34, FontWeight.normal, 1.2);
      check(t.headlineSmall, 24, FontWeight.bold, 1.3);
      check(t.titleLarge, 20, FontWeight.normal, 1.3);
      check(t.titleMedium, 16, FontWeight.normal, 1.4);
      check(t.titleSmall, 14, FontWeight.w700, 1.4);
      check(t.bodyLarge, 16, FontWeight.w500, 1.3);
      check(t.bodyMedium, 14, FontWeight.normal, 1.3);
      check(t.bodySmall, 12, FontWeight.normal, 1.3);
      check(t.labelLarge, 14, FontWeight.w700, 1.2);
      check(t.labelSmall, 10, FontWeight.normal, 1.2);
      expect(t.headlineLarge, isNull);
      expect(t.labelMedium, isNull);
    });

    test('cores vêm da paleta (texto e texto de botão)', () {
      final TextTheme light = LelloTextStyles.themeWith(LightPallete());
      final TextTheme dark = LelloTextStyles.themeWith(DarkPallete());
      expect(light.bodyMedium?.color, LightPallete().text());
      expect(light.labelLarge?.color, LightPallete().buttonText());
      expect(dark.bodyMedium?.color, DarkPallete().text());
      expect(dark.labelLarge?.color, DarkPallete().buttonText());
    });
  });

  group('atalhos de estilo', () {
    final theme = LelloTheme.light;

    test('mapeiam para os slots do TextTheme', () {
      expect(LelloTextStyles.headline(theme), theme.textTheme.displayLarge);
      expect(LelloTextStyles.title(theme), theme.textTheme.headlineSmall);
      expect(LelloTextStyles.titleSmall(theme), theme.textTheme.titleLarge);
      expect(LelloTextStyles.subtitle(theme), theme.textTheme.titleMedium);
      expect(LelloTextStyles.body(theme), theme.textTheme.bodyMedium);
      expect(LelloTextStyles.bodyBold(theme), theme.textTheme.titleSmall);
      expect(LelloTextStyles.button(theme), theme.textTheme.labelLarge);
      expect(LelloTextStyles.caption(theme), theme.textTheme.bodySmall);
    });

    test('variações bold/normal mantêm tamanho e mudam peso', () {
      expect(LelloTextStyles.titleBold(theme)!.fontWeight, FontWeight.bold);
      expect(LelloTextStyles.titleBold(theme)!.fontSize, 24);
      expect(
          LelloTextStyles.titleSmallBold(theme)!.fontWeight, FontWeight.bold);
      expect(LelloTextStyles.titleSmallBold(theme)!.fontSize, 20);
      expect(LelloTextStyles.subtitleBold(theme)!.fontWeight, FontWeight.bold);
      expect(LelloTextStyles.subtitleBold(theme)!.fontSize, 16);
      expect(LelloTextStyles.subBody(theme)!.fontWeight, FontWeight.normal);

      /// Corrigido: o comentário agora diz "Tamanho 16.0" — `subBody` deriva
      /// de `bodyLarge` (16.0); o valor não mudou.
      expect(LelloTextStyles.subBody(theme)!.fontSize, 16);
      expect(LelloTextStyles.captionBold(theme)!.fontWeight, FontWeight.bold);
      expect(LelloTextStyles.captionBold(theme)!.fontSize, 12);
    });

    test('error e inverseButton usam a paleta do tema', () {
      expect(LelloTextStyles.error(theme)!.color, LightPallete().error());
      expect(LelloTextStyles.error(theme)!.fontSize, 14);
      expect(LelloTextStyles.inverseButton(theme)!.color,
          LightPallete().buttonLink());
      expect(LelloTextStyles.inverseButton(theme)!.fontWeight, FontWeight.w700);

      final dark = LelloTheme.dark;
      expect(LelloTextStyles.error(dark)!.color, DarkPallete().error());
      expect(LelloTextStyles.inverseButton(dark)!.color,
          DarkPallete().buttonLink());
    });
  });

  testWidgets('golden com todos os estilos', (tester) async {
    await pumpApp(
      tester,
      Builder(builder: (context) {
        final theme = Theme.of(context);
        final estilos = <String, TextStyle?>{
          'headline': LelloTextStyles.headline(theme),
          'title': LelloTextStyles.title(theme),
          'titleBold': LelloTextStyles.titleBold(theme),
          'titleSmall': LelloTextStyles.titleSmall(theme),
          'titleSmallBold': LelloTextStyles.titleSmallBold(theme),
          'subtitle': LelloTextStyles.subtitle(theme),
          'subtitleBold': LelloTextStyles.subtitleBold(theme),
          'body': LelloTextStyles.body(theme),
          'bodyBold': LelloTextStyles.bodyBold(theme),
          'subBody': LelloTextStyles.subBody(theme),
          'button': LelloTextStyles.button(theme)
              ?.copyWith(backgroundColor: theme.primaryColor),
          'error': LelloTextStyles.error(theme),
          'inverseButton': LelloTextStyles.inverseButton(theme),
          'captionBold': LelloTextStyles.captionBold(theme),
          'caption': LelloTextStyles.caption(theme),
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in estilos.entries) Text(e.key, style: e.value),
          ],
        );
      }),
      surface: const Size(400, 620),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/lello_text_styles.png'));
  });
}
