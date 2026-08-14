import 'package:lello/feature/agreements/domain/entity/payment_method.dart';

class AgreementsRules {
  int installmentQtd;
  List<int> days;
  // List<String> paymentMethod;
  AgreementsRules({
    required this.installmentQtd,
    required this.days,
    // required this.paymentMethod,
  });

  String get getAllowedDays {
    String value = "";
    if (days.isNotEmpty) {
      days.sort((a, b) => a.compareTo(b));
      days.forEach((element) {
        value = "$value$element , ";
      });
      value = value.substring(0, value.length - 3);
    }
    return value;
  }

  String get getMaxInstallments => "${installmentQtd}x";

  List<String> get paymentMethod => PaymentMethod.getList;

  List<String> get getpaymentMethodsKeyList {
    List<String> list = [];
    if (paymentMethod.isNotEmpty) {
      paymentMethod.forEach((paymentMethod) {
        String paymentMethodKey =
            PaymentMethod.getPaymentMethodKey(paymentMethod);
        if (paymentMethodKey.isNotEmpty) {
          list.add(paymentMethodKey);
        }
      });
    }
    return list;
  }
}
