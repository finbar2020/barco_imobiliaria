import 'package:essentials/configs/flavor_config.dart';
import 'package:essentials/configs/hubert_configuration.dart';
import 'package:essentials/configs/lello_configuration.dart';
import 'package:flutter/services.dart' show appFlavor;
import 'package:flutter_test/flutter_test.dart';

/// `appFlavor` é uma constante de compilação (`--dart-define=FLUTTER_APP_FLAVOR`).
/// Na suíte padrão ela é nula, então só os ramos `default` (Lello) são
/// alcançáveis; os `case 'hubert'`/`case 'lello'` exigem rodar com
/// `--dart-define=FLUTTER_APP_FLAVOR=hubert|lello`. Os testes abaixo se
/// adaptam ao flavor compilado para passar nos dois cenários.
void main() {
  test('init escolhe a marca pelo flavor nativo', () {
    FlavorConfig.init();
    if (appFlavor == 'hubert') {
      expect(FlavorConfig.config, isA<HubertConfiguration>());
      expect(FlavorConfig.currentBrand, Brand.hubert);
      expect(FlavorConfig.isHubert, isTrue);
      expect(FlavorConfig.isLello, isFalse);
    } else {
      expect(FlavorConfig.config, isA<LelloConfiguration>());
      expect(FlavorConfig.currentBrand, Brand.lello);
      expect(FlavorConfig.isLello, isTrue);
      expect(FlavorConfig.isHubert, isFalse);
    }
  });

  test('name expõe o flavor ou "Não definido"', () {
    expect(FlavorConfig.name, appFlavor ?? 'Não definido');
  });

  test('currentBrand funciona antes do init e não depende de config', () {
    expect(FlavorConfig.currentBrand,
        appFlavor == 'hubert' ? Brand.hubert : Brand.lello);
  });

  test('helpers booleanos seguem a config ativa', () {
    FlavorConfig.config = const HubertConfiguration();
    expect(FlavorConfig.isHubert, isTrue);
    expect(FlavorConfig.isLello, isFalse);
    expect(FlavorConfig.config.brandName, 'Hubert');

    FlavorConfig.config = const LelloConfiguration();
    expect(FlavorConfig.isLello, isTrue);
    expect(FlavorConfig.isHubert, isFalse);
    expect(FlavorConfig.config.brandName, 'Lello');
  });

  test('init pode ser chamado de novo e restaura a marca do flavor', () {
    FlavorConfig.config = const HubertConfiguration();
    FlavorConfig.init();
    expect(FlavorConfig.isHubert, appFlavor == 'hubert');
  });

  test('Brand tem as duas marcas', () {
    expect(Brand.values, [Brand.lello, Brand.hubert]);
  });
}
