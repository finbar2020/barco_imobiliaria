import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account_type.dart';

class ResinBankAccount {
  String id;
  ResinBank? bank;
  String agency;
  String accountNumber;
  String document;
  String supplierName;
  ResinBankAccountType accountType;

  ResinBankAccount(
      {this.id = "",
      required this.bank,
      required this.agency,
      required this.accountNumber,
      required this.document,
      required this.supplierName,
      this.accountType = ResinBankAccountType.other});

  bool get isValid {
    if (bank == null) {
      return false;
    }
    if (agency.isEmpty) {
      return false;
    }
    if (accountNumber.isEmpty) {
      return false;
    }
    if (document.isEmpty) {
      return false;
    }
    if (supplierName.isEmpty) {
      return false;
    }
    if (accountType == ResinBankAccountType.other) {
      return false;
    }
    return true;
  }
}
