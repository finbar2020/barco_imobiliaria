import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';

class AgreementCreated {
  String unit;
  int paymentMethod;
  int installmentQuantity;
  int dueDate;
  int reference;
  List<String> receiptList;
  String? email;
  String? phone;

  double totalValue;

  String get chosenPaymentMethod {
    if (paymentMethod == AgreementPaymentMethodEnum.billet.index) {
      return "income_billet_detail_billet";
    } else {
      return "agreements_creditcard_bank";
    }
  }

  AgreementCreated({
    this.unit = "",
    this.paymentMethod = 0,
    this.installmentQuantity = 0,
    this.dueDate = 0,
    this.reference = 0,
    this.receiptList = const [],
    this.totalValue = 0,
    this.email = "",
    this.phone = "",
  });
}
