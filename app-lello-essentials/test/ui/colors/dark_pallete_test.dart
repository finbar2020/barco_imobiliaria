import 'package:essentials/ui/colors/color_pallete.dart';
import 'package:essentials/ui/colors/dark_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  test('DarkPallete é singleton e implementa ColorPallete', () {
    expect(identical(DarkPallete(), DarkPallete()), isTrue);
    expect(DarkPallete(), isA<ColorPallete>());
  });

  test('cores padrão da paleta escura', () {
    final p = DarkPallete();
    expect(p.primary(), darkPrimaryDefault);
    expect(p.secondary(), darkSecondaryDefault);
    expect(p.accent(), p.secondary());
    expect(p.background(), const Color(0xFF000000));
    expect(p.backgroundDark(), const Color(0x89000000));
    expect(p.contrastBackground(), const Color(0xFFF5F5F5));
    expect(p.error(), const Color(0xFFFF0000));
    expect(p.negative(), const Color(0xFFF22200));
    expect(p.overlay(), const Color(0x89000000));
    expect(p.separator(), const Color(0xFFECECEC));
    expect(p.success(), const Color(0xFF42B883));
    expect(p.raffle(), const Color(0xFF4D86F4));
    expect(p.routineBlue(), const Color(0xFF0058A0));
    expect(p.warning(), const Color(0xFFFF8A00));
    expect(p.secondGradient(), const Color(0xFF8F0F23));
    expect(p.customColor(), const Color(0xFF000000));
    expect(p.crimsonRed(), const Color(0xFFE5073E));
    expect(p.hubertSindico(), const Color(0xFF0C3959));
    expect(p.hubertMorador(), const Color(0xFF36ACE2));
  });

  test('cores de texto, botão, app bar e card', () {
    final p = DarkPallete();
    expect(p.text(), const Color(0xFFFFFFFF));
    expect(p.textLight(), const Color(0x89FFFFFF));
    expect(p.textLightest(), const Color(0x44FFFFFF));
    expect(p.hubText(), const Color(0xFFFFFFFF));
    expect(p.textAccent(), const Color(0xFF2F80ED));
    expect(p.grey(), Colors.grey);
    expect(p.greyDarker(), const Color(0xFF2D2D2D));
    expect(p.textOpaque(), const Color(0xFF828282));
    expect(p.purpleText(), const Color(0xFF922885));
    expect(p.button(), const Color(0xFFFFFFFF));
    expect(p.buttonText(), const Color(0xFF000000));
    expect(p.buttonLink(), p.text());
    expect(p.buttonSystem(), const Color(0xFF2F80ED));
    expect(p.secondaryButtonBorder(), const Color(0xFFFFFFFF));
    expect(p.whatsappButton(), const Color(0xFF1BD741));
    expect(p.appBar(), p.primary());
    expect(p.appBarHome(), p.primary());
    expect(p.statusBarColor(), p.primary());

    /// Defeito (registrado, não corrigido): `greyCard` da paleta escura é o
    /// mesmo cinza claro (F5F5F5) da paleta clara, sem contraste com o fundo
    /// preto. É usado como fundo de cards em ~15 pontos de 4 apps (morar,
    /// sindico, colaborador, shared/comfort) cujo conteúdo não foi auditado
    /// para um fundo escuro; a troca cega poderia quebrar esses layouts.
    expect(p.greyCard(), const Color(0xFFF5F5F5));
    expect(palleteEntries(p).length, 38);
  });

  test(
      'factory com primary/secondary devolve nova instância sem mutar o singleton',
      () {
    final custom = DarkPallete(primary: Colors.teal, secondary: Colors.amber);
    expect(custom.primary(), Colors.teal);
    expect(custom.secondary(), Colors.amber);
    expect(custom.accent(), Colors.amber);
    expect(custom.appBar(), Colors.teal);
    expect(custom.buttonLink(), const Color(0xFFFFFFFF));
    expect(identical(custom, DarkPallete()), isFalse);
    expect(DarkPallete().primary(), darkPrimaryDefault);
    expect(DarkPallete().secondary(), darkSecondaryDefault);

    final soPrimary = DarkPallete(primary: Colors.pink);
    expect(soPrimary.primary(), Colors.pink);
    expect(soPrimary.secondary(), darkSecondaryDefault);

    final soSecondary = DarkPallete(secondary: Colors.lime);
    expect(soSecondary.primary(), darkPrimaryDefault);
    expect(soSecondary.secondary(), Colors.lime);
  });

  test('customize altera o singleton e restoreDefaults restaura', () {
    expect(DarkPallete.defaultPrimary, darkPrimaryDefault);
    expect(DarkPallete.defaultSecondary, darkSecondaryDefault);
    DarkPallete.customize(primary: Colors.teal, secondary: Colors.amber);
    expect(DarkPallete().primary(), Colors.teal);
    expect(DarkPallete().secondary(), Colors.amber);
    DarkPallete.customize(primary: Colors.pink);
    expect(DarkPallete().primary(), Colors.pink);
    expect(DarkPallete().secondary(), Colors.amber);
    DarkPallete.customize(secondary: Colors.lime);
    expect(DarkPallete().primary(), Colors.pink);
    expect(DarkPallete().secondary(), Colors.lime);
    expect(identical(DarkPallete.restoreDefaults(), DarkPallete()), isTrue);
    expect(DarkPallete().primary(), darkPrimaryDefault);
    expect(DarkPallete().secondary(), darkSecondaryDefault);
  });

  testWidgets('golden da paleta escura', (tester) async {
    await pumpApp(tester, palleteSwatches(DarkPallete()),
        surface: const Size(400, 560));
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('../goldens/pallete_dark.png'));
  });
}
