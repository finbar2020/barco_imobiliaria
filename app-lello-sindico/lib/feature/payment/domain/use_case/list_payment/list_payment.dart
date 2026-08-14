import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';

abstract class ListPayment extends UseCase<List<Payment>, ListPaymentParam> {}

class ListPaymentParam {
  final String condominiumId;
  final String? lastRegistrationId;
  final PaymentListFilter? filter;
  final String? status;

  ListPaymentParam(
      {required this.condominiumId,
      this.lastRegistrationId,
      this.filter,
      this.status});
}
