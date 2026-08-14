import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';

class AccountabilityGroupedAccount {
  int account;
  String description;
  List<AccountabilityGroupedAccaountEntrie> entries;

  AccountabilityGroupedAccount({
    required this.account,
    required this.description,
    required this.entries,
  });

  double get getTotalCredit =>
      entries.map((e) => e.credit).reduce((a, b) => a + b);
  double get getTotalDebit =>
      entries.map((e) => e.debit).reduce((a, b) => a + b);

  double get getTotal => getTotalCredit - getTotalDebit;

  bool get creditOnly => !entries.any((element) => element.debit > 0);
}
