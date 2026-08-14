import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/update_ledger_account/update_ledger_account.dart';

class UpdateLedgerAccountImpl extends UpdateLedgerAccount {
  final PaymentRepository repository;

  UpdateLedgerAccountImpl({required this.repository});

  @override
  Future<Try<bool>> call(UpdateLedgerAccountParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return repository.updateLedgerAccount(
      params.condominiumId,
      params.idLancamento,
      params.idContaContabil,
    );
  }

  Failure? _validate(UpdateLedgerAccountParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
