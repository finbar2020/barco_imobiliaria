import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/get_document/get_document.dart';

class GetDocumentImpl extends GetDocument {
  final VoxRepository repository;

  GetDocumentImpl({required this.repository});

  @override
  Future<Try<DocumentDetail>> call(GetDocumentParam? params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.getDocument(params!.type, params.id);
  }

  Failure? validate(GetDocumentParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.id.isEmpty) return InvalidParamFailure();
    return null;
  }
}
