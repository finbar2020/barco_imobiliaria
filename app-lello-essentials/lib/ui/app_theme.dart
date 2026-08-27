import 'package:essentials/ui/colors/carimbeira_pallete.dart';
import 'package:essentials/ui/widget/app_bar/lello_app_bar_styles.dart';
import 'package:essentials/ui/widget/button/lello_button_styles.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';

import 'colors/color_pallete.dart';
import 'colors/dark_pallete.dart';
import 'colors/light_pallete.dart';

class LelloTheme {
  static final light = themeWithPallete(Brightness.light, LightPallete());
  static final dark = themeWithPallete(Brightness.dark, DarkPallete());
  static final carimbeira =
      themeWithPallete(Brightness.light, CarimbeiraPallete());

  static ThemeData themeWithPallete(
          Brightness brightness, ColorPallete pallete) =>
      ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: pallete.accent(),
          brightness: brightness,
          primary: pallete.primary(),
          shadow: pallete.hubText(),
          tertiary: pallete.raffle(),
          surface: Colors.white,
          onSurface: pallete.text(),
          outline: pallete.separator(),
          secondaryContainer: pallete.primary(),
        ),
        dividerTheme: DividerThemeData(
          color: pallete.separator(),
          thickness: 1,
          space: 0,
        ),
        checkboxTheme: CheckboxThemeData(
          side: BorderSide(color: pallete.grey(), width: 2),
          fillColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return pallete.secondary();
              }
              return null;
            },
          ),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),
        primaryColor: pallete.primary(),
        secondaryHeaderColor: pallete.secondary(),
        scaffoldBackgroundColor: pallete.background(),
        canvasColor: pallete.background(),
        cardColor: pallete.background(),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: pallete.background(),
        ),
        buttonTheme: LelloButtonStyles.themeWith(pallete),
        textTheme: LelloTextStyles.themeWith(pallete),
        appBarTheme: LelloAppBarStyles.themeWith(pallete),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          backgroundColor: pallete.background(),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: pallete.textOpaque()),
        ),
        splashColor: pallete.primary().withOpacity(0.2),
        highlightColor: pallete.primary().withOpacity(0.1),
        chipTheme: ChipThemeData(
          showCheckmark: false,
        ),
        // Registra a paleta usada para que `palleteOf` a recupere depois.
        extensions: <ThemeExtension<dynamic>>[_PalleteExtension(pallete)],
      );

  /// Paleta de um tema. Temas criados por [themeWithPallete] devolvem a
  /// própria paleta com que foram criados (inclusive instâncias customizadas,
  /// preservadas por `copyWith`). Para outros temas o brilho decide entre
  /// clara e escura, e a carimbeira só é reconhecida (pela cor primária) em
  /// temas claros.
  static ColorPallete palleteOf(ThemeData data) {
    final registered = data.extension<_PalleteExtension>()?.pallete;
    if (registered != null) return registered;
    if (data.brightness == Brightness.dark) return DarkPallete();
    if (data.primaryColor.value == CarimbeiraPallete().primary().value) {
      return CarimbeiraPallete();
    }
    return LightPallete();
  }

  /// Tema "viver": aplica preto como primary/secondary no singleton
  /// [LightPallete] (efeito global do qual os apps viver dependem).
  static ThemeData get viverDefaultTheme => themeWithPallete(Brightness.light,
      LightPallete.customize(primary: Colors.black, secondary: Colors.black));

  /// Tema Lello padrão: restaura explicitamente o vermelho Lello no singleton
  /// [LightPallete] (desfaz o efeito de [viverDefaultTheme]).
  static ThemeData get lelloDefaultTheme =>
      themeWithPallete(Brightness.light, LightPallete.restoreDefaults());

  LelloTheme._();
}

/// Extensão de tema que guarda a [ColorPallete] usada em
/// [LelloTheme.themeWithPallete], para [LelloTheme.palleteOf] não depender de
/// heurísticas por cor.
class _PalleteExtension extends ThemeExtension<_PalleteExtension> {
  const _PalleteExtension(this.pallete);

  final ColorPallete pallete;

  @override
  ThemeExtension<_PalleteExtension> copyWith({ColorPallete? pallete}) =>
      _PalleteExtension(pallete ?? this.pallete);

  @override
  ThemeExtension<_PalleteExtension> lerp(
          ThemeExtension<_PalleteExtension>? other, double t) =>
      other is _PalleteExtension && t >= 0.5 ? other : this;
}
