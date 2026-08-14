/// Contrato (interface) que define todas as configurações específicas de cada marca.
///
/// Cada marca implementa esta classe com seus próprios valores.
/// Para acessar a configuração da marca ativa, use [FlavorConfig.config].
///
/// Uso:
/// ```dart
/// final email = FlavorConfig.config.supportEmail;
/// final whatsapp = FlavorConfig.config.supportWhatsAppNumber;
/// ```
abstract class BrandConfiguration {
  /// Nome da marca
  String get brandName;

  /// Nome da IA da marca (ex.: Bella, Beth)
  String get iaName;

  /// Número do WhatsApp de app síndico suporte
  String get supportSindicoWhatsAppNumber;

  /// Número do WhatsApp de app morador suporte
  String get supportMoradorWhatsAppNumber;

  /// Número do WhatsApp de app colaborador suporte
  String get supportColaboradorWhatsAppNumber;

  /// URL dos termos de serviço
  String get termsOfServiceUrl;

  /// Nome do app
  String get appName;

  /// Email de suporte/atendimento
  String get supportEmail;

  /// ID da empresa na API
  int get idEmpresa;

  @override
  String toString() => 'BrandConfiguration(brand: $brandName)';
}
