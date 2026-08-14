import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_reasons/list_document_reasons.dart';

class ListDocumentReasonsImpl extends ListDocumentReasons {
  final VoxRepository repository;

  ListDocumentReasonsImpl({required this.repository});

  @override
  Future<Try<List<DocumentReason>>> call(
      ListDocumentReasonsParam? params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.listReasons(params!.type, params.condominiumId);
  }

  Failure? validate(ListDocumentReasonsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
