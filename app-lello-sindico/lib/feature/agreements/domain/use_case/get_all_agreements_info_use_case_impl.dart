import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_all_info.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:lello/feature/agreements/domain/use_case/get_all_agreements_info_use_case.dart';

class GetAllAgreementsInfoUseCaseImpl extends GetAllAgreementsInfoUseCase {
  final AgreementsRepository repository;

  GetAllAgreementsInfoUseCaseImpl({required this.repository});
  @override
  Future<Try<AgreementsAllInfo?>> call(
      GetAllAgreementsInfoParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    final future = params.origin == DataOrigin.local
        ? await repository
            .selectAllAgreementsInfoFromCache(params.condominiumId)
        : await repository.getAllAgreementsInfo(params.condominiumId);
    return future;
  }

  Failure? _validate(GetAllAgreementsInfoParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
