import 'package:morar/feature/accountability/domain/entity/account_monthly_finance.dart';
import 'package:morar/feature/accountability/domain/entity/account_monthly_summary.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';

class Accountability {
  String? condominiumId;
  DateTime? period;
  List<AccountMonthlyFinance?> accounts;
  List<AccountMonthlySummary?> summary;
  double? initialBalance;
  double? totalIncome;
  double? totalExpenses;
  double? balance;
  List<AccountabilityGrouped> groupedEntries;

  Accountability({
    this.condominiumId,
    this.period,
    this.accounts = const [],
    this.summary = const [],
    this.initialBalance,
    this.totalIncome,
    this.totalExpenses,
    this.balance,
    this.groupedEntries = const [],
  });

  @override
  String toString() {
    return 'Accountability(condominiumId: $condominiumId, period: $period, accounts: $accounts, summary: $summary, initialBalance: $initialBalance, totalIncome: $totalIncome, totalExpenses: $totalExpenses, balance: $balance)';
  }
}
