/// Detalhe de um documento, carregado por id (Q7: o detalhe sempre re-busca).
///
/// Unifica os detalhes de advertência (`Warnings`), multa (`Fines`) e comunicado
/// (`AnnouncementsDetails`). O comunicado é o único que traz `recipientList`
/// (string) e `occurrenceDate` no endpoint de detalhe.
class DocumentDetail {
  String? id;
  String? name;
  String? description;

  /// Conteúdo em Base64 (decodificado para HTML na presentation).
  String? content;

  String? status;
  int? pagesQuantity;
  String? createdAt;
  DateTime? occurrenceDate;

  bool? flagEmailDistribution;
  bool? flagPrintDistribution;

  /// Destinatários (string) — presente no detalhe de comunicado.
  String? recipientList;

  DocumentDetail();
}
