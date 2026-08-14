import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/cnd/domain/repository/cnd_repository.dart';
import 'package:morar/feature/easy_fix/cnd/domain/use_case/cnd_pdf_use_case.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';

class CndPdfUseCaseImpl extends CndPdfUseCase {
  final CndRepository repository;

  CndPdfUseCaseImpl({required this.repository});
  @override
  Future<Try<DocumentFile>> call(CndPdfParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.generateCertificateNoOutstandingDebt(
        params.condominiumId, params.unitProfileEntity);
  }

  Failure? _validate(CndPdfParams params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
