import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';

class AgreementPaymentMethod {
  AgreementPaymentMethodEnum type;
  bool enabled;
  String text;
  String description;
  String disabledDescription;

  AgreementPaymentMethod(
      {required this.type,
      required this.enabled,
      required this.text,
      required this.description,
      required this.disabledDescription});

  String getIcon() {
    switch (type) {
      case AgreementPaymentMethodEnum.credit:
        return "assets/ic_agreement_credit.svg";
      case AgreementPaymentMethodEnum.billet:
        return "assets/ic_agreement_billet.svg";
      case AgreementPaymentMethodEnum.undef:
        return "assets/ic_agreement_billet.svg";
      default:
        return "assets/ic_agreement_billet.svg";
    }
  }

  String getTitle() {
    switch (type) {
      case AgreementPaymentMethodEnum.credit:
        return "agreements_credit";
      case AgreementPaymentMethodEnum.billet:
        return "income_billet_detail_billet";
      case AgreementPaymentMethodEnum.undef:
        return "income_billet_detail_billet";
      default:
        return "income_billet_detail_billet";
    }
  }
}
