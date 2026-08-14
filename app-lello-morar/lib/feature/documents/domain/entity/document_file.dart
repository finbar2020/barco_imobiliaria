import 'dart:io';

class DocumentFile {
  String? id;
  String? name;
  String? type;
  String? documentName;

  /// **Deprecado** — base64 do arquivo. Ainda usado por features legadas
  /// (billets, cnd) que dependem do endpoint base64. No fluxo novo de
  /// documents, use `localFile`.
  @Deprecated('Use localFile (File). Mantido vivo para billets/cnd.')
  String? data;

  /// **Deprecado** — texto extraído inline. No fluxo novo, obtenha via
  /// `loadExtractedText` (lazy).
  @Deprecated('Use loadExtractedText (lazy). Mantido vivo para billets/cnd.')
  String? extractedText;

  /// Arquivo PDF gravado em disco pelo `DocumentsCacheManager`. Padrão novo.
  File? localFile;

  /// Closure lazy para obter o texto extraído (acessibilidade). Resolve
  /// `null` se o backend não tiver texto extraído ou se a chamada falhar.
  Future<String?> Function()? loadExtractedText;

  DocumentFile({
    this.id,
    this.name,
    this.type,
    this.documentName,
    // ignore: deprecated_member_use_from_same_package
    this.data,
    // ignore: deprecated_member_use_from_same_package
    this.extractedText,
    this.localFile,
    this.loadExtractedText,
  });

  @override
  String toString() {
    return 'DocumentFile(id: $id, name: $name, type: $type, localFile: ${localFile?.path})';
  }
}
