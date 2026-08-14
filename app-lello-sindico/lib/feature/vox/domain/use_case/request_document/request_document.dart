import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

abstract class RequestDocument extends UseCase<String, RequestDocumentParam> {}

class RequestDocumentParam {
  final DocumentType type;
  final String condominiumId;
  final DocumentRequest request;

  RequestDocumentParam({
    required this.type,
    required this.condominiumId,
    required this.request,
  });
}
