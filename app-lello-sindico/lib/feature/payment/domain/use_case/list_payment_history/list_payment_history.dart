import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';

abstract class ListPaymentHistory
    extends UseCase<List<PaymentHistoryItem>, ListPaymentHistoryParam> {}

class ListPaymentHistoryParam {
  final String condominiumId;
  final DateTime? startDate;
  final DateTime? endDate;

  ListPaymentHistoryParam({
    required this.condominiumId,
    this.startDate,
    this.endDate,
  });
}
