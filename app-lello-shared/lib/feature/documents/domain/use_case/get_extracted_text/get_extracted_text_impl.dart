import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_type.dart';
import 'package:shared_features/feature/documents/domain/repository/documents_repository.dart';
import 'package:shared_features/feature/documents/domain/use_case/get_extracted_text/get_extracted_text.dart';

class GetExtractedTextImpl extends GetExtractedText {
  final DocumentsRepository repository;

  GetExtractedTextImpl({required this.repository});

  @override
  Future<Try<String>> call(GetExtractedTextParam params) async {
    if (params.documentId.isEmpty || params.documentType.isEmpty) {
      return Rejection(InvalidParamFailure());
    }

    return await repository.getExtractedText(
      params.documentId,
      documentTypeToApiNumber(params.documentType),
    );
  }
}
