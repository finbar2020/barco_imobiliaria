import 'package:lello/feature/payment/data/model/ledger_account_balance_model.dart';

abstract class PaymentLedgerAccountBalanceDataSource {
  Future<LedgerAccountBalanceModel> getLedgerAccountBalance(
      String condoId, String accountId);
}
