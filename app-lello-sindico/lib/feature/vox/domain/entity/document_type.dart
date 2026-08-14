import 'package:lello/feature/vox/domain/entity/document_mode.dart';

/// Tipo de documento do síndico unificado (advertência, multa, comunicado).
///
/// Centraliza o que antes estava triplicado e/ou hardcoded:
///   * o `serviceId` da solicitação (item B4 — antes hardcoded nas entities);
///   * quais campos extras o wizard renderiza (motivo, template, valor, data);
///   * quais modos de envio o tipo suporta.
enum DocumentType {
  warning,
  fine,
  announcement,
}

extension DocumentTypeConfig on DocumentType {
  /// Id do serviço usado em POST /requests/service. Contrato com o backend.
  String get serviceId {
    switch (this) {
      case DocumentType.warning:
        return "790850";
      case DocumentType.fine:
        return "790851";
      case DocumentType.announcement:
        return "790829";
    }
  }

  /// Tem seleção de motivo no passo de dados (advertência/multa).
  bool get hasReasons =>
      this == DocumentType.warning || this == DocumentType.fine;

  /// Carrega/exibe o seletor de modelo/template no passo de dados. Advertência
  /// e multa usam em qualquer modo (o fio leva o id do modelo). Comunicado só
  /// na criação — a solicitação (/requests/service) não carrega template.
  bool usesTemplates(DocumentMode mode) {
    switch (this) {
      case DocumentType.warning:
      case DocumentType.fine:
        return true;
      case DocumentType.announcement:
        return mode == DocumentMode.create;
    }
  }

  /// Tem campo de valor (apenas multa).
  bool get hasValue => this == DocumentType.fine;

  /// Tem data de ocorrência (advertência/multa, não comunicado).
  bool get hasOccurrenceDate =>
      this == DocumentType.warning || this == DocumentType.fine;

  /// Tem campo de título (comunicado).
  bool get hasTitle => this == DocumentType.announcement;

  /// Tem campo de cópias para elevador (comunicado).
  bool get hasCopies => this == DocumentType.announcement;

  /// Tem o seletor "enviar para" (Todos/Bloco/Unidade — comunicado). Advertência
  /// e multa selecionam diretamente as unidades.
  bool get hasRecipientTypeSelector => this == DocumentType.announcement;

  /// Modos de envio suportados. Multa só pode ser solicitada.
  Set<DocumentMode> get supportedModes => this == DocumentType.fine
      ? const {DocumentMode.request}
      : const {DocumentMode.create, DocumentMode.request};

  bool get supportsCreate => supportedModes.contains(DocumentMode.create);
}
