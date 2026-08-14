import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/create_document/create_document.dart';

class CreateDocumentImpl extends CreateDocument {
  final VoxRepository repository;

  CreateDocumentImpl({required this.repository});

  @override
  Future<Try<String>> call(CreateDocumentParam? params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.createDocument(params!.type, params.request);
  }

  Failure? validate(CreateDocumentParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
