import 'package:essentials/configs/brand_configuration.dart';
import 'package:essentials/configs/hubert_configuration.dart';
import 'package:essentials/configs/lello_configuration.dart';
import 'package:flutter/services.dart';

/// Define os tipos de flavors disponíveis no app.
/// Mantido para uso legítimo em switches estruturais (ex.: inicialização do Firebase).
enum Brand {
  lello,
  hubert,
}

class FlavorConfig {
  /// Configuração de marca ativa.
  /// Deve ser inicializada via [init] no [main], antes do [runApp].
  static late BrandConfiguration config;

  /// Inicializa a [config] com base no flavor nativo.
  /// Deve ser chamada uma única vez em [main], antes do [runApp].
  static void init() {
    switch (appFlavor) {
      case 'hubert':
        config = const HubertConfiguration();
        break;
      case 'lello':
      default:
        config = const LelloConfiguration();
        break;
    }
  }

  /// Retorna o [Brand] atual diretamente do flavor nativo.
  /// Pode ser usado antes de [init] (ex.: handlers de background do Firebase).
  static Brand get currentBrand {
    switch (appFlavor) {
      case 'lello':
        return Brand.lello;
      case 'hubert':
        return Brand.hubert;
      default:
        return Brand.lello;
    }
  }

  /// Helper para debug
  static String get name => appFlavor ?? 'Não definido';

  /// Helpers booleanos são derivados do [config] inicializado.
  /// Requerem que [init] tenha sido chamado antes do uso.
  static bool get isLello => config is LelloConfiguration;
  static bool get isHubert => config is HubertConfiguration;
}
