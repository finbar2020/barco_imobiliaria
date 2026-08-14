import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';

abstract class SendPayment extends UseCase<int?, SendPaymentParams> {}

class SendPaymentParams {
  final String condoId;
  final PaymentDataEntity data;

  SendPaymentParams({
    required this.condoId,
    required this.data,
  });
}
