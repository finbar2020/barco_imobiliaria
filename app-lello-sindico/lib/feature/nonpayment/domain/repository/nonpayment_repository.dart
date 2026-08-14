import 'package:essentials/essentials.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';

abstract class NonPaymentsRepository {
  Future<Try<NonPayment>> list(String condominiumId);
}
