import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_templates/list_document_templates.dart';

class ListDocumentTemplatesImpl extends ListDocumentTemplates {
  final VoxRepository repository;

  ListDocumentTemplatesImpl({required this.repository});

  @override
  Future<Try<List<DocumentTemplate>>> call(
      ListDocumentTemplatesParam? params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.listTemplates(params!.type, params.condominiumId);
  }

  Failure? validate(ListDocumentTemplatesParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
