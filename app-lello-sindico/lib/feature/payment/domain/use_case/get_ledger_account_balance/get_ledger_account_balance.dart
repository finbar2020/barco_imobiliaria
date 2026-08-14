import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/ledger_account_balance_model.dart';

abstract class GetLedgerAccountBalance
    extends UseCase<LedgerAccountBalanceModel, GetLedgerAccountBalanceParam> {}

class GetLedgerAccountBalanceParam {
  final String condominiumId;
  final String accountId;

  GetLedgerAccountBalanceParam(
      {required this.condominiumId, required this.accountId});
}
