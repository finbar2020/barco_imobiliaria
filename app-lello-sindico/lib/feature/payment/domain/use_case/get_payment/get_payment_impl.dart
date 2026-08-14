import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment.dart';

class GetPaymentImpl extends GetPayment {
  final PaymentRepository repository;

  GetPaymentImpl({required this.repository});

  @override
  Future<Try<Payment?>> call(GetPaymentParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.find(params.condominiumId,
        params.supplierIdentification, params.documentNumber);
  }

  Failure? _validate(GetPaymentParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.documentNumber.isEmpty) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.supplierIdentification.isEmpty) return InvalidParamFailure();
    return null;
  }
}
