import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/repository/payment_approval_repository.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment_approval/register_payment_approval.dart';

class RegisterPaymentApprovalImpl extends RegisterPaymentApproval {
  final PaymentApprovalRepository repository;

  RegisterPaymentApprovalImpl({required this.repository});
  @override
  Future<Try<PaymentApproval>> call(RegisterPaymentApprovalParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.insert(params.condominiumId, params.approval);
  }

  Failure? validate(RegisterPaymentApprovalParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
