import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment.dart';

class ListPaymentImpl extends ListPayment {
  final PaymentRepository repository;

  ListPaymentImpl({required this.repository});

  @override
  Future<Try<List<Payment>>> call(ListPaymentParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId,
        lastPaymentId: params.lastRegistrationId,
        filter: params.filter,
        status: params.status);
  }

  Failure? _validate(ListPaymentParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
