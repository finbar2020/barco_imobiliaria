import 'package:essentials/configs/brand_configuration.dart';

/// Configurações da marca Hubert.
class HubertConfiguration implements BrandConfiguration {
  const HubertConfiguration();

  @override
  String get brandName => 'Hubert';

  @override
  String get iaName => 'Beth';

  @override
  String get supportSindicoWhatsAppNumber => '551131463980';

  @override
  String get supportMoradorWhatsAppNumber => '551131463910';

  @override
  String get supportColaboradorWhatsAppNumber => '551131463911';

  @override
  String get termsOfServiceUrl =>
      'https://conteudo.hubert.com.br/termos-de-uso/';

  @override
  String get appName => 'Hubert';

  @override
  String get supportEmail => 'atendimento.condominios@hubert.com.br';

  @override
  int get idEmpresa => 2;
}
