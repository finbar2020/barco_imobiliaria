import 'dart:typed_data';

/// Anexo de uma solicitação de documento.
///
/// Unifica os três tipos idênticos antigos (`WarningsAttachments`,
/// `FinesAttachments`, `AnnouncementAttachments`).
///
/// Carrega os **bytes crus** do arquivo — a conversão para Base64 (formato de
/// transporte) é responsabilidade da camada data (item B5), feita no
/// `fromEntity` do model. A presentation não conhece Base64.
class DocumentAttachment {
  /// MIME type (ex.: "application/pdf", "image/jpeg").
  String? type;

  /// Bytes crus do arquivo.
  Uint8List? bytes;

  /// Nome do arquivo (ex.: "doc.pdf").
  String? name;

  DocumentAttachment({this.type, this.bytes, this.name});
}
