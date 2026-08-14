import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

/// Item de histórico/lista de documento (advertência, multa, comunicado).
///
/// Unifica `Warnings`, `Fines` e `Announcements`. Campos só presentes em alguns
/// tipos (motivo, modelo, valor, data) são opcionais; cada model de leitura
/// preenche o que seu endpoint retorna.
class Document {
  String? id;
  String? name;
  String? description;

  /// Conteúdo em Base64 (como vem do backend na lista). A decodificação para
  /// exibição é feita na presentation/detalhe.
  String? content;

  String? status;
  int? pagesQuantity;

  /// Data de criação como string (normalizada na camada data).
  String? createdAt;

  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  bool? flagEmailBodyAttachment;

  // Específicos de advertência/multa.
  String? reason;
  String? reasonId;
  String? modelId;
  DateTime? occurrenceDate;
  String? unityId;
  RecipientType? recipientType;
  int? singleCopiesQuantity;
  String? value;

  Document();

  /// Data de referência para agrupar o histórico por período. Advertência/multa
  /// trazem [occurrenceDate]; comunicado só tem [createdAt] (ISO). Cai para nulo
  /// quando nenhuma data é parseável.
  DateTime? get periodDate =>
      occurrenceDate ?? DateTime.tryParse(createdAt ?? "");
}
