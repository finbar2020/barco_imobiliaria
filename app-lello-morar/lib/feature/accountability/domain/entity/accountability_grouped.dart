import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account.dart';

class AccountabilityGrouped {
  String type;
  String description;
  int id;
  double debits;
  double credits;
  List<AccountabilityGroupedAccount> accounts;

  AccountabilityGrouped(
      {required this.type,
      required this.description,
      required this.id,
      required this.debits,
      required this.credits,
      required this.accounts});
}
