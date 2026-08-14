import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis.dart';

abstract class GetAnalysisUseCase
    extends UseCase<AgreementsAnalysis, GetAnalysisParams> {}

class GetAnalysisParams {
  String condominiumId;
  String? fromDate;
  String? toDate;
  GetAnalysisParams({
    required this.condominiumId,
    required this.fromDate,
    required this.toDate,
  });
}
