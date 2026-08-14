import 'package:shared_features/feature/documents/data/model/documents_response_model.dart';

abstract class DocumentsRemoteDataSource {
  Future<List<DocumentsResponseModel>> listDocuments(
      String condominiumId, String documentType, String unitId);
}
