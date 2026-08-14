import 'package:colaborador/feature/documents/data/model/document_file_model.dart';
import 'package:colaborador/feature/documents/data/model/document_info_model.dart';

abstract class DocumentsRemoteDataSource {
  Future<List<DocumentInfoModel>> getDocumentsInfoList(String condoId,
      String documentType, DateTime? dateFrom, DateTime? dateTo);

  Future<DocumentFileModel> getDocumentFile(String documentName);
}
