import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_ledger_account_balance_datasource.dart';
import 'package:lello/feature/payment/data/model/ledger_account_balance_model.dart';
import 'package:lello/feature/payment/domain/repository/payment_ledger_account_balance_repository.dart';

class PaymentLedgerAccountBalanceRepositoryImpl
    extends PaymentLedgerAccountBalanceRepository {
  final PaymentLedgerAccountBalanceDataSource dataSource;

  PaymentLedgerAccountBalanceRepositoryImpl(this.dataSource);

  @override
  Future<Try<LedgerAccountBalanceModel>> getLedgerAccountBalance(
      String condoId, String accountId) async {
    try {
      final ledgerAccountBalance =
          await dataSource.getLedgerAccountBalance(condoId, accountId);
      return Success(ledgerAccountBalance);
    } catch (e) {
      if (e is ApiFailure) {
        switch (e.status) {
          case 400:
            return Rejection(KnownFailure(e.title?.toString() ?? "", e));
          default:
            return Rejection(UnknownFailure(e));
        }
      }
      return Rejection(UnknownFailure(e));
    }
  }
}
