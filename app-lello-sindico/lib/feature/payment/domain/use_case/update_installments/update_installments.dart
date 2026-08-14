import 'package:essentials/base/use_case.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_lancamento_entity.dart';

abstract class UpdateInstallments
    extends UseCase<bool, UpdateInstallmentsParam> {}

class UpdateInstallmentsParam {
  final String condominiumId;
  final UpdateInstallmentLancamentoEntity body;

  UpdateInstallmentsParam({
    required this.condominiumId,
    required this.body,
  });
}
