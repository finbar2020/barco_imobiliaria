import 'package:lello/feature/payment/domain/use_case/get_ledger_account_balance/get_ledger_account_balance.dart';

class RegisterLedgerAccountController {
  final GetLedgerAccountBalance getLedgerAccountBalanceUseCase;

  RegisterLedgerAccountController(this.getLedgerAccountBalanceUseCase);

  Future<double?> getLedgerAccountBalance(
      String condoId, String accountId) async {
    final result =
        await getLedgerAccountBalanceUseCase(GetLedgerAccountBalanceParam(
      condominiumId: condoId,
      accountId: accountId,
    ));
    return result.fold(
      (failure) {
        return null;
      },
      (success) {
        return success.balance;
      },
    );
  }
}
