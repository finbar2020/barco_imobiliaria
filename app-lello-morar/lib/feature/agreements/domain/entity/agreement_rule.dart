import 'package:morar/feature/agreements/domain/entity/agreement_payment_method.dart';

class AgreementRule {
  int installmentQtd;
  List<int> days;
  List<AgreementPaymentMethod> paymentMethod;

  AgreementRule({
    required this.installmentQtd,
    required this.days,
    required this.paymentMethod,
  });
}
