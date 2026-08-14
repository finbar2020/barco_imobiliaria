import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/repository/documents_repository.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:essentials/essentials.dart';

class GetDocumentsInfoListUsecaseImpl extends GetDocumentsInfoListUseCase {
  final DocumentsRepository repository;

  GetDocumentsInfoListUsecaseImpl({required this.repository});
  @override
  Future<Try<List<DocumentInfo>>> call(GetDocumentsInfoListParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.getDocumentsInfoList(
      params.condoId,
      params.documentType,
      params.dateFrom,
      params.dateTo,
    );
  }

  Failure? validate(GetDocumentsInfoListParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    if (enumToString(params.documentType) == null) return InvalidParamFailure();

    return null;
  }
}
