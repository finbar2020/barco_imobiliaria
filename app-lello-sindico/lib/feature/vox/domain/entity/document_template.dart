/// Template/modelo de um documento. Unifica `WarningTemplate` e `FinesTemplate`,
/// que eram idênticos.
///
/// Nota: corrige a dívida técnica A2 — o `AnnouncementsTemplateModel.toEntity()`
/// antigo retornava `FinesTemplate` por copy-paste; aqui há um tipo único.
class DocumentTemplate {
  String? id;
  String? name;
  String? description;
  String? group;
  String? thumbnail;

  DocumentTemplate();
}
