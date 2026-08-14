import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/ledger_account_balance_model.dart';

abstract class PaymentLedgerAccountBalanceRepository {
  Future<Try<LedgerAccountBalanceModel>> getLedgerAccountBalance(
      String condoId, String accountId);
}
