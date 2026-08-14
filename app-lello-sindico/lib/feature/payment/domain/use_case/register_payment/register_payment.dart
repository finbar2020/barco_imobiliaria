import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';

abstract class RegisterPayment
    extends UseCase<Payment?, RegisterPaymentParams> {}

class RegisterPaymentParams {
  final String condominiumId;
  final Payment payment;
  final List<int>? paymentFile;
  RegisterPaymentParams(
      {required this.condominiumId, required this.payment, this.paymentFile});
}
