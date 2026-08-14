import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:lello/feature/agreements/domain/use_case/get_analysis_use_case.dart';

class GetAnalysisUseCaseImpl extends GetAnalysisUseCase {
  final AgreementsRepository repository;

  GetAnalysisUseCaseImpl({required this.repository});
  @override
  Future<Try<AgreementsAnalysis>> call(GetAnalysisParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getAnalysis(
      params.condominiumId,
      params.fromDate,
      params.toDate,
    );
  }

  Failure? _validate(GetAnalysisParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
