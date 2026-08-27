import 'package:essentials/ui/colors/color_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  test('LightPallete é singleton e implementa ColorPallete', () {
    final a = LightPallete();
    final b = LightPallete();
    expect(identical(a, b), isTrue);
    expect(a, isA<ColorPallete>());
  });

  test('cores padrão da paleta clara', () {
    final p = LightPallete();
    expect(p.primary(), lightPrimaryDefault);
    expect(p.secondary(), lightSecondaryDefault);
    expect(p.accent(), p.secondary());
    expect(p.background(), const Color(0xFFFFFFFF));
    expect(p.backgroundDark(), const Color(0xFFF7F7F9));
    expect(p.contrastBackground(), const Color(0xFF822730));
    expect(p.error(), const Color(0xFFFF0000));
    expect(p.negative(), const Color(0xFFF22200));
    expect(p.overlay(), const Color(0x89000000));
    expect(p.separator(), const Color(0xFFE0E0E0));
    expect(p.raffle(), const Color(0xFF4D86F4));
    expect(p.routineBlue(), const Color(0xFF0058A0));
    expect(p.warning(), const Color(0xFFFF8A00));
    expect(p.success(), const Color(0xFF42B883));
    expect(p.secondGradient(), const Color(0xFF8F0F23));
    expect(p.customColor(), const Color(0xFFFFFFFF));
    expect(p.crimsonRed(), const Color(0xFFE5073E));
    expect(p.hubertSindico(), const Color(0xFF0C3959));
    expect(p.hubertMorador(), const Color(0xFF36ACE2));
  });

  test('cores de texto, botão, app bar e card', () {
    final p = LightPallete();
    expect(p.text(), const Color(0xFF000000));
    expect(p.textLight(), const Color(0x89000000));
    expect(p.textLightest(), const Color(0x44000000));
    expect(p.hubText(), const Color(0xFF494949));
    expect(p.textAccent(), const Color(0xFF2F80ED));
    expect(p.grey(), const Color(0xFF606062));
    expect(p.greyDarker(), const Color(0xFF2D2D2D));
    expect(p.textOpaque(), const Color(0xFF828282));
    expect(p.purpleText(), const Color(0xFF922885));
    expect(p.button(), const Color(0xFFCB2640));
    expect(p.buttonText(), const Color(0xFFFFFFFF));
    expect(p.buttonLink(), p.primary());
    expect(p.buttonSystem(), const Color(0xFF2F80ED));
    expect(p.secondaryButtonBorder(), p.separator());
    expect(p.whatsappButton(), const Color(0xFF1BD741));
    expect(p.appBar(), p.primary());
    expect(p.appBarHome(), p.primary());
    expect(p.statusBarColor(), p.primary());
    expect(p.greyCard(), const Color(0xFFF5F5F5));
    expect(palleteEntries(p).length, 38);
  });

  test('factory com primary/secondary devolve uma nova instância', () {
    final custom = LightPallete(primary: Colors.black, secondary: Colors.blue);
    expect(custom.primary(), Colors.black);
    expect(custom.secondary(), Colors.blue);
    expect(custom.accent(), Colors.blue);
    expect(custom.buttonLink(), Colors.black);
    expect(custom.appBar(), Colors.black);

    /// Corrigido: chamar a factory com parâmetros devolve uma NOVA instância;
    /// o singleton `LightPallete()` mantém as cores padrão.
    expect(identical(custom, LightPallete()), isFalse);
    expect(LightPallete().primary(), lightPrimaryDefault);
    expect(LightPallete().secondary(), lightSecondaryDefault);

    // Só `primary` informado herda o secondary do singleton.
    final soPrimary = LightPallete(primary: Colors.green);
    expect(soPrimary.primary(), Colors.green);
    expect(soPrimary.secondary(), lightSecondaryDefault);

    // Só `secondary` informado herda o primary do singleton.
    final soSecondary = LightPallete(secondary: Colors.orange);
    expect(soSecondary.primary(), lightPrimaryDefault);
    expect(soSecondary.secondary(), Colors.orange);
  });

  test('customize altera o singleton e restoreDefaults restaura', () {
    expect(LightPallete.defaultPrimary, lightPrimaryDefault);
    expect(LightPallete.defaultSecondary, lightSecondaryDefault);

    final s =
        LightPallete.customize(primary: Colors.black, secondary: Colors.blue);
    expect(identical(s, LightPallete()), isTrue);
    expect(LightPallete().primary(), Colors.black);
    expect(LightPallete().secondary(), Colors.blue);

    // Cores omitidas são mantidas.
    LightPallete.customize(primary: Colors.green);
    expect(LightPallete().primary(), Colors.green);
    expect(LightPallete().secondary(), Colors.blue);

    // Instâncias novas herdam as cores atuais do singleton.
    expect(LightPallete(secondary: Colors.orange).primary(), Colors.green);

    expect(identical(LightPallete.restoreDefaults(), LightPallete()), isTrue);
    expect(LightPallete().primary(), lightPrimaryDefault);
    expect(LightPallete().secondary(), lightSecondaryDefault);
  });

  testWidgets('golden da paleta clara', (tester) async {
    await pumpApp(tester, palleteSwatches(LightPallete()),
        surface: const Size(400, 560));
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('../goldens/pallete_light.png'));
  });
}
