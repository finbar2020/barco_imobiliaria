/// Item do menu de documentos. `documentType` é a chave de localização e o
/// identificador do tipo (ex.: "documents_minutes", "documents_notices",
/// "documents_circulars", "documents_divers").
class DocumentsMenuItem {
  final String documentType;
  const DocumentsMenuItem(this.documentType);
}

/// Itens padrão, na ordem de exibição usada pelos dois apps.
const List<DocumentsMenuItem> kDefaultDocumentsMenuItems = [
  DocumentsMenuItem("documents_minutes"),
  DocumentsMenuItem("documents_notices"),
  DocumentsMenuItem("documents_circulars"),
  DocumentsMenuItem("documents_divers"),
];
