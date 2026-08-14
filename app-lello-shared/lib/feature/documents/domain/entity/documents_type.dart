enum DocumentsType { main, atas, editais, circulares, outros }

/// Mapeia a chave de tipo (`documents_minutes`, etc.) para o número que a API
/// espera. Usado tanto na listagem quanto no download.
String documentTypeToApiNumber(String documentTypeKey) {
  switch (documentTypeKey) {
    case "documents_divers":
      return '0';
    case "documents_circulars":
      return '1';
    case "documents_minutes":
      return '2';
    case "documents_notices":
      return '3';
    default:
      return '';
  }
}
