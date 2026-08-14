import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:lello/feature/agreements/domain/use_case/agreement_update_status_use_case.dart';

class AgreementUpdateStatusUseCaseImpl extends AgreementUpdateStatusUseCase {
  final AgreementsRepository repository;

  AgreementUpdateStatusUseCaseImpl({required this.repository});
  @override
  Future<Try<Agreement>> call(AgreementUpdateStatusParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.agreementUpdateStatus(
        params.condominiumId, params.updateStatus);
  }

  Failure? _validate(AgreementUpdateStatusParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.updateStatus.agreementId.isEmpty) return InvalidParamFailure();
    if (params.updateStatus.userName.isEmpty) return InvalidParamFailure();

    return null;
  }
}
