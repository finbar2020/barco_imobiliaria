import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';

abstract class GetInstallmentCreditUseCase
    extends UseCase<List<AgreementInstallmentCredit>, GetInstallmentParams> {}

class GetInstallmentParams {
  final String condoId;
  final double totalValue;

  GetInstallmentParams({
    required this.condoId,
    required this.totalValue,
  });
}
