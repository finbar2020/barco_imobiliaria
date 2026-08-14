/// Motivo de um documento (advertência/multa). Unifica `WarningReasons` e
/// `FinesReasons`, que eram idênticos.
class DocumentReason {
  String? id;
  String? description;
  String? keywords;
  String? updatedAt;
  String? userId;
  bool? flagActive;

  DocumentReason();
}
