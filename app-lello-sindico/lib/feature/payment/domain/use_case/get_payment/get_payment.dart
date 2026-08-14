import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';

abstract class GetPayment extends UseCase<Payment?, GetPaymentParam> {}

class GetPaymentParam {
  final String condominiumId;
  final String supplierIdentification;
  final String documentNumber;

  GetPaymentParam(
      {required this.condominiumId,
      required this.supplierIdentification,
      required this.documentNumber});
}
