import 'package:colaborador/feature/documents/data/data_source/documents_api.dart';
import 'package:colaborador/feature/documents/data/data_source/documents_remote_data_source.dart';
import 'package:colaborador/feature/documents/data/model/document_file_model.dart';
import 'package:colaborador/feature/documents/data/model/document_info_model.dart';
import 'package:essentials/essentials.dart';

class DocumentsRemoteDataSourceImpl extends DocumentsRemoteDataSource {
  final DocumentsApi api;

  DocumentsRemoteDataSourceImpl({required this.api});

  @override
  Future<List<DocumentInfoModel>> getDocumentsInfoList(
    String condoId,
    String documentType,
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    final response =
        await api.getDocumentsInfoList(condoId, documentType, dateFrom, dateTo);

    return ApiMapper.mapList<DocumentInfoModel>(
        response, (json) => DocumentInfoModel.fromJson(json));
  }

  @override
  Future<DocumentFileModel> getDocumentFile(String documentName) async {
    final response = await api.getDocumentsFile(documentName);

    return ApiMapper.map<DocumentFileModel>(
        response, (json) => DocumentFileModel.fromJson(json));
  }
}
