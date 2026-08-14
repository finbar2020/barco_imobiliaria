import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_finished.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_refused.dart';

class AgreementsAnalysis {
  DateTime fromDate;
  DateTime toDate;
  AgreementsFinished? reportApproved;
  AgreementsRefused? reportReproved;
  AgreementsAnalysis({
    required this.fromDate,
    required this.toDate,
    this.reportApproved,
    this.reportReproved,
  });
}
