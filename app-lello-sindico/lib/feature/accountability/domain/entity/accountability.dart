import 'package:lello/feature/accountability/domain/entity/account_monthly_finance.dart';
import 'package:lello/feature/accountability/domain/entity/account_monthly_summary.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_recommendations.dart';

class Accountability {
  List<AccountMonthlyFinance?> accounts;
  List<AccountMonthlySummary?> summary;
  DateTime? period;
  String? condominiumId;
  double? initialBalance;
  double? totalIncome;
  double? totalExpenses;
  double? balance;
  Accountability({
    this.accounts = const [],
    this.summary = const [],
    this.groupedEntries = const [],
    this.recommendations = const [],
  });

  List<AccountabilityGrouped> groupedEntries;
  List<AccountabilityRecommendations> recommendations;
}
