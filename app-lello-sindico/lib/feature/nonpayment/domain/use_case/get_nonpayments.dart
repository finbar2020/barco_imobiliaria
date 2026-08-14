import 'package:essentials/essentials.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';

abstract class GetNonPayments extends UseCase<NonPayment, GetNonPaymentsParam> {
}

class GetNonPaymentsParam {
  final String condominiumId;
  final String period;

  GetNonPaymentsParam({required this.condominiumId, required this.period});
}
