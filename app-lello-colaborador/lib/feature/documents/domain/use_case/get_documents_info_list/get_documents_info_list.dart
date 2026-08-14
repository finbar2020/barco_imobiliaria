import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:essentials/essentials.dart';

abstract class GetDocumentsInfoListUseCase
    extends UseCase<List<DocumentInfo>, GetDocumentsInfoListParam> {}

class GetDocumentsInfoListParam {
  final String condoId;
  final DocumentTypeEnum documentType;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  GetDocumentsInfoListParam({
    required this.condoId,
    required this.documentType,
    this.dateFrom,
    this.dateTo,
  });
}
