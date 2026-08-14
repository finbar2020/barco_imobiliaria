import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

abstract class ListDocumentTemplates
    extends UseCase<List<DocumentTemplate>, ListDocumentTemplatesParam> {}

class ListDocumentTemplatesParam {
  final DocumentType type;
  final String condominiumId;

  ListDocumentTemplatesParam({required this.type, required this.condominiumId});
}
