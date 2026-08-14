import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/list_documents/list_documents.dart';

class ListDocumentsImpl extends ListDocuments {
  final VoxRepository repository;

  ListDocumentsImpl({required this.repository});

  @override
  Future<Try<List<Document>>> call(ListDocumentsParam? params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.listDocuments(params!.type, params.condominiumId);
  }

  Failure? validate(ListDocumentsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
