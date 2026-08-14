import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installments.dart';

abstract class GetInstallments
    extends UseCase<List<PaymentInstallments>, GetInstallmentsParam> {}

class GetInstallmentsParam {
  final String condominiumId;
  final String paymentId;

  GetInstallmentsParam({required this.condominiumId, required this.paymentId});
}
