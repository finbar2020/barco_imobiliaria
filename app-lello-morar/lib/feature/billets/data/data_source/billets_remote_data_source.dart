import 'package:morar/feature/documents/data/model/document_file_response_model.dart';
import 'package:essentials/paginator/paginator_model.dart';

abstract class BilletsRemoteDataSource {
  Future<PaginatorModel> getBillets(String reference, String unitId,
      {bool showAll = false});
  Future<DocumentFileResponseModel> getBilletPdf(String nrBillet);
}
