import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/update_installments/update_installments.dart';

class UpdateInstallmentsImpl extends UpdateInstallments {
  final PaymentRepository repository;

  UpdateInstallmentsImpl({required this.repository});

  @override
  Future<Try<bool>> call(UpdateInstallmentsParam param) async {
    final error = _validate(param);
    if (error != null) return Rejection(error);
    return await repository.updateInstallment(param.condominiumId, param.body);
  }

  Failure? _validate(UpdateInstallmentsParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
