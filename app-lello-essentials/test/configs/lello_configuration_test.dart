import 'package:essentials/configs/brand_configuration.dart';
import 'package:essentials/configs/lello_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const config = LelloConfiguration();

  test('é uma BrandConfiguration constante', () {
    expect(config, isA<BrandConfiguration>());
    expect(identical(config, const LelloConfiguration()), isTrue);
  });

  test('valores da marca Lello', () {
    expect(config.brandName, 'Lello');
    expect(config.iaName, 'Bella');
    expect(config.supportSindicoWhatsAppNumber, '551127977588');
    expect(config.supportMoradorWhatsAppNumber, '551127977585');
    expect(config.supportColaboradorWhatsAppNumber, '551127977586');
    expect(config.termsOfServiceUrl, 'https://lello.com.br/termos-de-uso');
    expect(config.appName, 'Lello');
    expect(config.supportEmail, 'atendimento.condominios@lello.com.br');
    expect(config.idEmpresa, 1);
  });

  test('os três WhatsApps de suporte são distintos', () {
    expect({
      config.supportSindicoWhatsAppNumber,
      config.supportMoradorWhatsAppNumber,
      config.supportColaboradorWhatsAppNumber,
    }.length, 3);
  });
}
