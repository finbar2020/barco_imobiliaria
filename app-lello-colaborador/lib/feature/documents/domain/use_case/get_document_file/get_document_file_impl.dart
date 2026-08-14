import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/domain/repository/documents_repository.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_document_file/get_document_file.dart';
import 'package:essentials/essentials.dart';

class GetDocumentFileUsecaseImpl extends GetDocumentFileUseCase {
  final DocumentsRepository repository;

  GetDocumentFileUsecaseImpl({required this.repository});
  @override
  Future<Try<DocumentFile>> call(GetDocumentFileParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getDocumentFile(params.documentName);
  }

  Failure? validate(GetDocumentFileParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.documentName.isEmpty) return InvalidParamFailure();

    return null;
  }
}
