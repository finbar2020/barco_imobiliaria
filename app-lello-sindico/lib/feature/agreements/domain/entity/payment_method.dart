class PaymentMethod {
  static const billet = "billet";
  static const credit = "credit";

  static List<String> get getList => [billet, credit];

  static String getPaymentMethodKey(String? paymentMethod) {
    switch (paymentMethod) {
      case billet:
        return "agreements_billet";
      case credit:
        return "agreements_credit_card";
      default:
        return "";
    }
  }
}
