import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:essentials/essentials.dart';

abstract class GetDocumentFileUseCase
    extends UseCase<DocumentFile, GetDocumentFileParam> {}

class GetDocumentFileParam {
  final String documentName;

  GetDocumentFileParam({
    required this.documentName,
  });
}
