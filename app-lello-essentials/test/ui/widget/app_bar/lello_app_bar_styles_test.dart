import 'package:essentials/ui/colors/carimbeira_pallete.dart';
import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/app_bar/lello_app_bar_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  test('tema da app bar usa as cores da paleta clara', () {
    final AppBarTheme theme = LelloAppBarStyles.themeWith(LightPallete());
    expect(theme.backgroundColor, LightPallete().appBar());
    expect(theme.iconTheme!.color, LightPallete().appBar());
    expect(theme.elevation, 0);
    final overlay = theme.systemOverlayStyle!;
    expect(overlay.statusBarColor, LightPallete().statusBarColor());
    expect(overlay.statusBarBrightness, Brightness.dark);
    expect(overlay.statusBarIconBrightness, Brightness.light);
    expect(overlay.systemNavigationBarIconBrightness, Brightness.light);
  });

  test('acompanha as demais paletas', () {
    final AppBarTheme dark = LelloAppBarStyles.themeWith(DarkPallete());
    expect(dark.backgroundColor, DarkPallete().appBar());
    final AppBarTheme carimbeira =
        LelloAppBarStyles.themeWith(CarimbeiraPallete());
    expect(carimbeira.backgroundColor, carimbeiraPrimaryDefault);
    expect(carimbeira.systemOverlayStyle!.statusBarColor,
        carimbeiraPrimaryDefault);
  });
}
