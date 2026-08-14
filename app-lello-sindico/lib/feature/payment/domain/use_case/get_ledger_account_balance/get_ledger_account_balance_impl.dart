import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/ledger_account_balance_model.dart';
import 'package:lello/feature/payment/domain/repository/payment_ledger_account_balance_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_account_balance/get_ledger_account_balance.dart';

class GetLedgerAccountBalanceImpl extends GetLedgerAccountBalance {
  final PaymentLedgerAccountBalanceRepository repository;

  GetLedgerAccountBalanceImpl(this.repository);

  @override
  Future<Try<LedgerAccountBalanceModel>> call(
      GetLedgerAccountBalanceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return await repository.getLedgerAccountBalance(
        params.condominiumId, params.accountId);
  }

  Failure? _validate(GetLedgerAccountBalanceParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.accountId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
