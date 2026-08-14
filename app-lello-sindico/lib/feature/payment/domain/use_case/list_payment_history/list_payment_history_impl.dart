import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment_history/list_payment_history.dart';

class ListPaymentHistoryImpl extends ListPaymentHistory {
  final PaymentRepository repository;

  ListPaymentHistoryImpl({required this.repository});

  @override
  Future<Try<List<PaymentHistoryItem>>> call(
      ListPaymentHistoryParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.listPaymentHistory(
        params.condominiumId, params.startDate, params.endDate);
  }

  Failure? _validate(ListPaymentHistoryParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
