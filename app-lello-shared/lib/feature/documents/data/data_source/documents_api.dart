import 'package:chopper/chopper.dart';

part 'documents_api.chopper.dart';

@ChopperApi()
abstract class DocumentsApi extends ChopperService {
  /// Lista os documentos de uma unidade (morador). Host Morar suporta a rota
  /// com `unit`.
  @GET(
      path:
          "/documents/condominium/{condominium_id}/type/{document_type}/unit/{unit_id}")
  Future<Response> getDocumentsByUnit(
    @Path("condominium_id") String condominiumId,
    @Path("document_type") String documentType,
    @Path("unit_id") String unitId,
  );

  /// Lista os documentos do condomínio inteiro (síndico). Ambos os hosts
  /// (Legacy/Síndico e Morar) suportam a rota sem `unit`.
  @GET(path: "/documents/condominium/{condominium_id}/type/{document_type}")
  Future<Response> getDocumentsByCondominium(
    @Path("condominium_id") String condominiumId,
    @Path("document_type") String documentType,
  );

  static DocumentsApi create(ChopperClient client) {
    return _$DocumentsApi(client);
  }
}

/// Caminhos relativos dos endpoints binários (consumidos via
/// `DocumentsCacheManager().getSingleFile(...)`, fora do Chopper, para
/// aproveitar cache em disco + ETag).
class DocumentsBinaryPaths {
  static String download(String documentType, String documentId) =>
      '/documents/type/$documentType/$documentId/downloadRaw';

  static String text(String documentType, String documentId) =>
      '/documents/type/$documentType/$documentId/extractedText';
}
