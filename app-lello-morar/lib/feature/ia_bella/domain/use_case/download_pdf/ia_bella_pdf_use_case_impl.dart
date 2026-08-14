import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_pdf_entity.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';
import 'package:morar/feature/ia_bella/domain/use_case/download_pdf/ia_bella_pdf_user_case.dart';

class IaBellaPdfUseCaseImpl extends IaBellaPdfUseCase {
  IaBellaRepository repository;

  IaBellaPdfUseCaseImpl({required this.repository});

  @override
  Future<Try<IaBellaPdfEntity>> call(IaBellaPdfParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.downloadPdf(
        params.condominiumId, params.documentId, params.serviceType);
  }

  Failure? _validate(IaBellaPdfParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.documentId.isEmpty) return InvalidParamFailure();
    if (param.serviceType.isEmpty) return InvalidParamFailure();
    return null;
  }
}
