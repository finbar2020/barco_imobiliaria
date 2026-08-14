import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

abstract class ListDocumentReasons
    extends UseCase<List<DocumentReason>, ListDocumentReasonsParam> {}

class ListDocumentReasonsParam {
  final DocumentType type;
  final String condominiumId;

  ListDocumentReasonsParam({required this.type, required this.condominiumId});
}
