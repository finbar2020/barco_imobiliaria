import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';

class DocumentInfo {
  final String name;
  final DocumentTypeEnum type;
  final DateTime documentProcessingDate;

  DocumentInfo({
    required this.name,
    required this.type,
    required this.documentProcessingDate,
  });
}
