import 'package:chopper/chopper.dart';

part 'documents_api.chopper.dart';

@ChopperApi()
abstract class DocumentsApi extends ChopperService {
  @Get(path: "digitalRepository/documents_info/{documentType}")
  Future<Response> getDocumentsInfoList(
    @Path("id") String id,
    @Path("documentType") String documentType,
    @Query("dateFrom") DateTime? dateFrom,
    @Query("dateTo") DateTime? dateTo,
  );

  @Get(path: "digitalRepository/documents/{document_name}")
  Future<Response> getDocumentsFile(
    @Path("document_name") String documentName,
  );

  static DocumentsApi create(ChopperClient client) {
    return _$DocumentsApi(client);
  }
}
