import 'package:essentials/ui/colors/carimbeira_pallete.dart';
import 'package:essentials/ui/colors/color_pallete.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../ui_test_helpers.dart';

void main() {
  tearDown(resetPalletes);

  test('CarimbeiraPallete é singleton e implementa ColorPallete', () {
    expect(identical(CarimbeiraPallete(), CarimbeiraPallete()), isTrue);
    expect(CarimbeiraPallete(), isA<ColorPallete>());
  });

  test('cores padrão da paleta carimbeira', () {
    final p = CarimbeiraPallete();
    expect(p.primary(), carimbeiraPrimaryDefault);
    expect(p.secondary(), carimbeiraSecondaryDefault);
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
    expect(p.secondGradient(), p.secondary());
    expect(p.customColor(), const Color(0xFFFFFFFF));
    expect(p.crimsonRed(), const Color(0xFFE5073E));
    expect(p.hubertSindico(), const Color(0xFF0C3959));
    expect(p.hubertMorador(), const Color(0xFF36ACE2));
  });

  test('cores de texto, botão, app bar e card', () {
    final p = CarimbeiraPallete();
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

  test('carimbeira difere da clara apenas em primary/secondary/secondGradient',
      () {
    final carimbeira = palleteEntries(CarimbeiraPallete());
    final light = palleteEntries(LightPallete());
    final diff =
        carimbeira.keys.where((k) => carimbeira[k] != light[k]).toSet();
    expect(diff, {
      'primary',
      'secondary',
      'accent',
      'secondGradient',
      'buttonLink',
      'appBar',
      'appBarHome',
      'statusBarColor',
    });
  });

  test(
      'factory com primary/secondary devolve nova instância sem mutar o singleton',
      () {
    final custom =
        CarimbeiraPallete(primary: Colors.indigo, secondary: Colors.cyan);
    expect(custom.primary(), Colors.indigo);
    expect(custom.secondary(), Colors.cyan);
    expect(custom.secondGradient(), Colors.cyan);
    expect(custom.statusBarColor(), Colors.indigo);
    expect(identical(custom, CarimbeiraPallete()), isFalse);
    expect(CarimbeiraPallete().primary(), carimbeiraPrimaryDefault);
    expect(CarimbeiraPallete().secondary(), carimbeiraSecondaryDefault);

    expect(CarimbeiraPallete(primary: Colors.brown).secondary(),
        carimbeiraSecondaryDefault);
    expect(CarimbeiraPallete(secondary: Colors.yellow).primary(),
        carimbeiraPrimaryDefault);
  });

  test('customize altera o singleton e restoreDefaults restaura', () {
    expect(CarimbeiraPallete.defaultPrimary, carimbeiraPrimaryDefault);
    expect(CarimbeiraPallete.defaultSecondary, carimbeiraSecondaryDefault);
    CarimbeiraPallete.customize(primary: Colors.indigo, secondary: Colors.cyan);
    expect(CarimbeiraPallete().primary(), Colors.indigo);
    expect(CarimbeiraPallete().secondary(), Colors.cyan);
    CarimbeiraPallete.customize(primary: Colors.brown);
    expect(CarimbeiraPallete().secondary(), Colors.cyan);
    CarimbeiraPallete.customize(secondary: Colors.yellow);
    expect(CarimbeiraPallete().primary(), Colors.brown);
    expect(CarimbeiraPallete().secondary(), Colors.yellow);
    expect(identical(CarimbeiraPallete.restoreDefaults(), CarimbeiraPallete()),
        isTrue);
    expect(CarimbeiraPallete().primary(), carimbeiraPrimaryDefault);
    expect(CarimbeiraPallete().secondary(), carimbeiraSecondaryDefault);
  });

  testWidgets('golden da paleta carimbeira', (tester) async {
    await pumpApp(tester, palleteSwatches(CarimbeiraPallete()),
        surface: const Size(400, 560));
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../goldens/pallete_carimbeira.png'));
  });
}
