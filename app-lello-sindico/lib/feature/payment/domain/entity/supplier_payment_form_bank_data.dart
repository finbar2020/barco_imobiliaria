import 'package:lello/feature/payment/domain/entity/bank.dart';

class SupplierPaymentFormBankData {
  Bank? bank;
  String? agency;
  String? account;
  String? digit;
  String? type;

  SupplierPaymentFormBankData({
    this.bank,
    this.agency,
    this.account,
    this.digit,
    this.type,
  });
  @override
  String toString() {
    return 'SupplierPaymentFormBankData(bank: $bank, agency: $agency, account: $account, digit: $digit, type: $type)';
  }
}
