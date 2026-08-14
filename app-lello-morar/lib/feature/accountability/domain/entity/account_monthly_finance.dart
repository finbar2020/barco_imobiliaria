import 'package:morar/feature/accountability/domain/entity/account.dart';

class AccountMonthlyFinance {
  Account? account;
  double? income;
  double? expenses;
  double? initialBalance;
  double? balance;

  @override
  String toString() {
    return 'AccountMonthlyFinance(account: $account, income: $income, expenses: $expenses, initialBalance: $initialBalance, balance: $balance)';
  }
}
