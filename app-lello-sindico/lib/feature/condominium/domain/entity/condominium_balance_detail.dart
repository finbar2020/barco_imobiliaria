import 'condominium_balance_detail_debits.dart';
import 'condominium_balance_detail_summary.dart';

class CondominiumBalanceDetail {
  double? previousBalance;
  double? balance;
  double? accountBalance;
  double? debit;
  double? credits;
  List<Debits>? debits;
  List<Summary>? summary;
  String? reference;
  DateTime? lastUpdatedAt;
}
