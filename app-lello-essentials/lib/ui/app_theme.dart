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
      );

  static ColorPallete palleteOf(ThemeData data) {
    // Verifica se é o tema carimbeira baseado na cor primária
    if (data.primaryColor.value == CarimbeiraPallete().primary().value) {
      return CarimbeiraPallete();
    }
    return data.brightness == Brightness.light ? LightPallete() : DarkPallete();
  }

  static ThemeData get viverDefaultTheme => themeWithPallete(Brightness.light,
      LightPallete(primary: Colors.black, secondary: Colors.black));
  static ThemeData get lelloDefaultTheme => themeWithPallete(
      Brightness.light,
      LightPallete(
          primary: LightPallete().primary(),
          secondary: LightPallete().secondary()));

  LelloTheme._();
}
