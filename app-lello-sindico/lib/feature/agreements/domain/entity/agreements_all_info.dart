import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';

class AgreementsAllInfo {
  List<Agreement> agreements;
  AgreementsRules rule;

  AgreementsAllInfo({
    required this.agreements,
    required this.rule,
  });

  List<Agreement> get agreementsProposals {
    return agreements
        .where((element) => element.status == AgreementStatus.pending)
        .toList();
  }

  List<Agreement> get agreementsInProgress {
    return agreements
        .where((element) =>
            element.status == AgreementStatus.approvedAutomatically ||
            element.status == AgreementStatus.approvedByManager)
        .toList();
  }

  List<Agreement> get agreementsHistory {
    return agreements
        .where((element) =>
            element.status == AgreementStatus.cancelled ||
            element.status == AgreementStatus.rejected ||
            element.status == AgreementStatus.canceledAutomatically ||
            element.status == AgreementStatus.completed)
        .toList();
  }
}
