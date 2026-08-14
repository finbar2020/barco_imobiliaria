import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:essentials/essentials.dart';

abstract class DocumentsRepository {
  Future<Try<List<DocumentInfo>>> getDocumentsInfoList(String condoId,
      DocumentTypeEnum documentType, DateTime? dateFrom, DateTime? dateTo);

  Future<Try<DocumentFile>> getDocumentFile(String documentName);
}
