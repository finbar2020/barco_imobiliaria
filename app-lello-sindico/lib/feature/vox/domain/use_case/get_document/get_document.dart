import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

abstract class GetDocument extends UseCase<DocumentDetail, GetDocumentParam> {}

class GetDocumentParam {
  final DocumentType type;
  final String id;

  GetDocumentParam({required this.type, required this.id});
}
