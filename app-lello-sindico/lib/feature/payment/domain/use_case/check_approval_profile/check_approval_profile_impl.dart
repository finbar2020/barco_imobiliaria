import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile.dart';

class CheckApprovalProfileImpl extends CheckApprovalProfile {
  final PaymentRepository repository;

  CheckApprovalProfileImpl({required this.repository});

  @override
  Future<Try<bool>> call(CheckApprovalProfileParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.checkApprovalProfile(params.condominiumId);
  }

  Failure? _validate(CheckApprovalProfileParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
