import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/intallments_in_approval/get_installments_in_approval.dart';

class GetInstallmentsInApprovalImpl extends GetInstallmentsInApproval {
  final PaymentRepository repository;

  GetInstallmentsInApprovalImpl({required this.repository});

  @override
  Future<Try<List<PaymentInstallmentInApprovalEntity>>> call(
      GetInstallmentsInApprovalParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    final response = await repository.findInstallmentsInApproval(
      params.condominiumId,
      params.installmentId,
      params.dataCadastroDe,
      params.dataCadastroAte,
      params.status,
      params.filtrarAprovador,
    );
    return response;
  }

  Failure? _validate(GetInstallmentsInApprovalParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
