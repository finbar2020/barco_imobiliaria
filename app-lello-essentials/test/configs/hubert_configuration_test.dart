import 'package:essentials/configs/brand_configuration.dart';
import 'package:essentials/configs/hubert_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const config = HubertConfiguration();

  test('é uma BrandConfiguration constante', () {
    expect(config, isA<BrandConfiguration>());
    expect(identical(config, const HubertConfiguration()), isTrue);
  });

  test('valores da marca Hubert', () {
    expect(config.brandName, 'Hubert');
    expect(config.iaName, 'Beth');
    expect(config.supportSindicoWhatsAppNumber, '551131463980');
    expect(config.supportMoradorWhatsAppNumber, '551131463910');
    expect(config.supportColaboradorWhatsAppNumber, '551131463911');
    expect(config.termsOfServiceUrl,
        'https://conteudo.hubert.com.br/termos-de-uso/');
    expect(config.appName, 'Hubert');
    expect(config.supportEmail, 'atendimento.condominios@hubert.com.br');
    expect(config.idEmpresa, 2);
  });

  test('os três WhatsApps de suporte são distintos', () {
    expect({
      config.supportSindicoWhatsAppNumber,
      config.supportMoradorWhatsAppNumber,
      config.supportColaboradorWhatsAppNumber,
    }.length, 3);
  });
}
