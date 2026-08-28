import 'package:essentials/configs/brand_configuration.dart';
import 'package:essentials/configs/hubert_configuration.dart';
import 'package:essentials/configs/lello_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

/// Marca de teste que ESTENDE o contrato (herda o `toString`).
class _MarcaTeste extends BrandConfiguration {
  @override
  String get brandName => 'Teste';
  @override
  String get iaName => 'Tia';
  @override
  String get supportSindicoWhatsAppNumber => '1';
  @override
  String get supportMoradorWhatsAppNumber => '2';
  @override
  String get supportColaboradorWhatsAppNumber => '3';
  @override
  String get termsOfServiceUrl => 'https://teste';
  @override
  String get appName => 'App Teste';
  @override
  String get supportEmail => 'teste@teste.com';
  @override
  int get idEmpresa => 99;
}

void main() {
  test('toString do contrato mostra a marca', () {
    final marca = _MarcaTeste();
    expect(marca.toString(), 'BrandConfiguration(brand: Teste)');
    expect(marca.iaName, 'Tia');
    expect(marca.idEmpresa, 99);
  });

  /// Corrigido: `LelloConfiguration` e `HubertConfiguration` estendem o
  /// contrato (que ganhou construtor `const`) e herdam o `toString`.
  test('as marcas reais herdam o toString do contrato', () {
    expect(const LelloConfiguration().toString(),
        'BrandConfiguration(brand: Lello)');
    expect(const HubertConfiguration().toString(),
        'BrandConfiguration(brand: Hubert)');
  });

  test('as marcas reais cumprem o contrato', () {
    final marcas = <BrandConfiguration>[
      const LelloConfiguration(),
      const HubertConfiguration(),
    ];
    for (final marca in marcas) {
      expect(marca.brandName, isNotEmpty);
      expect(marca.iaName, isNotEmpty);
      expect(marca.supportSindicoWhatsAppNumber, matches(RegExp(r'^\d+$')));
      expect(marca.supportMoradorWhatsAppNumber, matches(RegExp(r'^\d+$')));
      expect(
          marca.supportColaboradorWhatsAppNumber, matches(RegExp(r'^\d+$')));
      expect(Uri.parse(marca.termsOfServiceUrl).isAbsolute, isTrue);
      expect(marca.appName, isNotEmpty);
      expect(marca.supportEmail, contains('@'));
      expect(marca.idEmpresa, greaterThan(0));
    }
    expect(marcas.map((m) => m.idEmpresa).toSet().length, 2,
        reason: 'ids de empresa são distintos');
  });
}
