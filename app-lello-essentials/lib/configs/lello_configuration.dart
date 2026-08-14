import 'package:essentials/configs/brand_configuration.dart';

/// Configurações da marca Lello.
class LelloConfiguration implements BrandConfiguration {
  const LelloConfiguration();

  @override
  String get brandName => 'Lello';

  @override
  String get iaName => 'Bella';

  @override
  String get supportSindicoWhatsAppNumber => '551127977588';

  @override
  String get supportMoradorWhatsAppNumber => '551127977585';

  @override
  String get supportColaboradorWhatsAppNumber => '551127977586';

  @override
  String get termsOfServiceUrl => 'https://lello.com.br/termos-de-uso';

  @override
  String get appName => 'Lello';

  @override
  String get supportEmail => 'atendimento.condominios@lello.com.br';

  @override
  int get idEmpresa => 1;
}
