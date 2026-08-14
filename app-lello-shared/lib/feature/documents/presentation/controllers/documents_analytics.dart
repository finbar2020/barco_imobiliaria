/// Estratégia de analytics da feature de documentos. A feature é compartilhada
/// entre apps com catálogos de evento distintos (morador no Morar, síndico no
/// Síndico), então o log é injetado: cada app mapeia o `documentType` para os
/// seus próprios eventos e puxa userId/unidade/referência da sua sessão.
abstract class DocumentsAnalytics {
  /// Chamado uma vez por carga, quando a lista de um tipo carrega com dados
  /// frescos do servidor.
  void logAccess(String documentType);

  /// Chamado quando o usuário compartilha um documento.
  void logShare(String documentType);
}

/// Implementação nula — para apps/contextos sem analytics de documentos.
class NoopDocumentsAnalytics implements DocumentsAnalytics {
  const NoopDocumentsAnalytics();

  @override
  void logAccess(String documentType) {}

  @override
  void logShare(String documentType) {}
}
