import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

abstract class ListDocuments
    extends UseCase<List<Document>, ListDocumentsParam> {}

class ListDocumentsParam {
  final DocumentType type;
  final String condominiumId;

  ListDocumentsParam({required this.type, required this.condominiumId});
}
