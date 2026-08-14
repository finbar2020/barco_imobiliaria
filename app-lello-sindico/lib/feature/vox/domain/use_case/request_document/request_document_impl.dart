import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/request_document/request_document.dart';

class RequestDocumentImpl extends RequestDocument {
  final VoxRepository repository;

  RequestDocumentImpl({required this.repository});

  @override
  Future<Try<String>> call(RequestDocumentParam? params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.requestDocument(params!.type, params.request);
  }

  Failure? validate(RequestDocumentParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
