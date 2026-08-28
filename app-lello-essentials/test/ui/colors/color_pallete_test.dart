import 'package:essentials/ui/colors/carimbeira_pallete.dart';
import 'package:essentials/ui/colors/color_pallete.dart';
import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../ui_test_helpers.dart';

/// Implementação mínima para garantir que o contrato abstrato pode ser
/// cumprido fora do pacote (todas as cores fixas).
class _FixedPallete implements ColorPallete {
  const _FixedPallete();
  Color _c() => const Color(0xFF123456);

  @override
  Color primary() => _c();
  @override
  Color secondary() => _c();
  @override
  Color accent() => _c();
  @override
  Color background() => _c();
  @override
  Color backgroundDark() => _c();
  @override
  Color contrastBackground() => _c();
  @override
  Color warning() => _c();
  @override
  Color raffle() => _c();
  @override
  Color routineBlue() => _c();
  @override
  Color success() => _c();
  @override
  Color error() => _c();
  @override
  Color negative() => _c();
  @override
  Color secondGradient() => _c();
  @override
  Color customColor() => _c();
  @override
  Color textLightest() => _c();
  @override
  Color crimsonRed() => _c();
  @override
  Color hubertSindico() => _c();
  @override
  Color hubertMorador() => _c();
  @override
  Color overlay() => _c();
  @override
  Color separator() => _c();
  @override
  Color grey() => _c();
  @override
  Color greyDarker() => _c();
  @override
  Color greyCard() => _c();
  @override
  Color button() => _c();
  @override
  Color buttonText() => _c();
  @override
  Color buttonLink() => _c();
  @override
  Color buttonSystem() => _c();
  @override
  Color secondaryButtonBorder() => _c();
  @override
  Color whatsappButton() => _c();
  @override
  Color text() => _c();
  @override
  Color textLight() => _c();
  @override
  Color hubText() => _c();
  @override
  Color textAccent() => _c();
  @override
  Color textOpaque() => _c();
  @override
  Color purpleText() => _c();
  @override
  Color appBar() => _c();
  @override
  Color appBarHome() => _c();
  @override
  Color statusBarColor() => _c();
}

void main() {
  tearDown(resetPalletes);

  test('contrato ColorPallete expõe 38 cores', () {
    final entries = palleteEntries(const _FixedPallete());
    expect(entries.length, 38);
    expect(entries.values.toSet(), {const Color(0xFF123456)});
  });

  test('todas as paletas do pacote cumprem o contrato sem cor nula', () {
    for (final pallete in <ColorPallete>[
      LightPallete(),
      DarkPallete(),
      CarimbeiraPallete(),
    ]) {
      final entries = palleteEntries(pallete);
      expect(entries.length, 38);
      expect(entries.values, everyElement(isA<Color>()));
    }
  });

  test('paletas clara e escura têm texto/fundo invertidos', () {
    expect(LightPallete().text(), DarkPallete().background());
    expect(LightPallete().background(), DarkPallete().text());
    expect(LightPallete().button(), isNot(DarkPallete().button()));
  });
}
