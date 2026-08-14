import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/get_installment_credit/get_installment_credit.dart';

class GetInstallmentCreditUseCaseImpl extends GetInstallmentCreditUseCase {
  final AgreementsRepository repository;

  GetInstallmentCreditUseCaseImpl({required this.repository});
  @override
  Future<Try<List<AgreementInstallmentCredit>>> call(
      GetInstallmentParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    var response = await repository.getInstallmentCredit(
      params.condoId,
      params.totalValue,
    );
    return response;
  }

  Failure? _validate(GetInstallmentParams? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
