import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';

abstract class PaymentApprovalRepository {
  Future<Try<PaymentApproval>> insert(
      String condominiumId, PaymentApproval approval);
}
