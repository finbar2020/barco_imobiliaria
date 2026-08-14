import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';

class AgreementsHistory {
  List<Agreement> agreements;

  AgreementsHistory({
    required this.agreements,
  });

  List<Agreement> get agreementsPaidList {
    return agreements
        .where((element) => element.status == AgreementStatus.completed)
        .toList();
  }

  List<Agreement> get agreementsCancelledList {
    return agreements
        .where((element) => element.status == AgreementStatus.cancelled)
        .toList();
  }

  List<Agreement> get agreementsDisapprovedList {
    return agreements
        .where((element) => element.status == AgreementStatus.rejected)
        .toList();
  }

  String get agreementsPaidTotal {
    return agreementsPaidList.length.toString();
  }

  String get agreementsCancelledTotal {
    return agreementsCancelledList.length.toString();
  }

  String get agreementsDisapprovedTotal {
    return agreementsDisapprovedList.length.toString();
  }
}
