import 'package:lello/feature/payment/domain/entity/bank.dart';

class PaymentFormBankDataEntity {
  final Bank? bank;
  final String? agency;
  final String? account;
  final String? digit;
  final String? type;

  PaymentFormBankDataEntity({
    this.bank,
    this.agency,
    this.account,
    this.digit,
    this.type,
  });
}
