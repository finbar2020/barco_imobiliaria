import 'package:essentials/essentials.dart';
import 'package:morar/feature/billets/domain/repository/billets_repository.dart';
import 'package:morar/feature/billets/domain/use_case/billets_pdf_use_case.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';

class BilletsPdfUseCaseImpl extends BilletsPdfUseCase {
  final BilletsRepository repository;

  BilletsPdfUseCaseImpl({required this.repository});
  @override
  Future<Try<DocumentFile>> call(BilletsPdfParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getPdf(params.nrBillet);
  }

  Failure? _validate(BilletsPdfParams params) {
    if (params.nrBillet.isEmpty) return InvalidParamFailure();
    return null;
  }
}
