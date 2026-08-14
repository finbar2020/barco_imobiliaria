import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/send_payment/send_payment.dart';

class SendPaymentImpl extends SendPayment {
  final PaymentRepository repository;

  SendPaymentImpl({required this.repository});

  @override
  Future<Try<int?>> call(SendPaymentParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.sendPayment(params.condoId, params.data);
  }

  Failure? _validate(SendPaymentParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
