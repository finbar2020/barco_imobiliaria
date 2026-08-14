import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_api.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_remote_data_source.dart';
import 'package:shared_features/feature/documents/data/model/documents_response_model.dart';

class DocumentsRemoteDataSourceImpl extends DocumentsRemoteDataSource {
  final DocumentsApi api;
  DocumentsRemoteDataSourceImpl({required this.api});

  @override
  Future<List<DocumentsResponseModel>> listDocuments(
      String condominiumId, String documentType, String unitId) async {
    final response = unitId.isEmpty
        ? await api.getDocumentsByCondominium(condominiumId, documentType)
        : await api.getDocumentsByUnit(condominiumId, documentType, unitId);
    final documents = ApiMapper.mapList(
        response, (json) => DocumentsResponseModel.fromJson(json));

    return documents;
  }
}
