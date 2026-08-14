import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

abstract class CreateDocument extends UseCase<String, CreateDocumentParam> {}

class CreateDocumentParam {
  final DocumentType type;
  final String condominiumId;
  final DocumentRequest request;

  CreateDocumentParam({
    required this.type,
    required this.condominiumId,
    required this.request,
  });
}
