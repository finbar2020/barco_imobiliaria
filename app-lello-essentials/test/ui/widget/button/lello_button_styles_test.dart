import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/button/lello_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../ui_test_helpers.dart';

/// Subclasse só para que `getFillColor` devolva o `buttonColor` do tema
/// (para `MaterialButton` puro ele devolve null por desenho do framework).
class _Botao extends MaterialButton {
  const _Botao() : super(onPressed: _noop);
  static void _noop() {}
}

void main() {
  tearDown(resetPalletes);

  test('tema de botão usa a cor de botão da paleta', () {
    final ButtonThemeData theme = LelloButtonStyles.themeWith(LightPallete());
    expect(theme.getFillColor(const _Botao()), LightPallete().button());
    expect(theme.height, 48.0);
    expect(theme.textTheme, ButtonTextTheme.normal);
    expect(theme.shape, isA<RoundedRectangleBorder>());
    expect((theme.shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(8));
  });

  test('cor do botão acompanha a paleta escura', () {
    final ButtonThemeData dark = LelloButtonStyles.themeWith(DarkPallete());
    expect(dark.getFillColor(const _Botao()), DarkPallete().button());
    expect(dark.getFillColor(const _Botao()),
        isNot(LelloButtonStyles.themeWith(LightPallete())
            .getFillColor(const _Botao())));
  });
}
