import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installments.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_installments/get_installments.dart';

class GetInstallmentsImpl extends GetInstallments {
  final PaymentRepository repository;

  GetInstallmentsImpl({required this.repository});

  @override
  Future<Try<List<PaymentInstallments>>> call(
      GetInstallmentsParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.findInstallments(
        params.condominiumId, params.paymentId);
  }

  Failure? _validate(GetInstallmentsParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.paymentId.isEmpty) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
