import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_final_evaluation_entity.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';
import 'package:morar/feature/ia_bella/domain/use_case/final_evaluation/ia_bella_final_evaluation_use_case.dart';

class IaBellaFinalEvaluationUseCaseImpl extends IaBellaFinalEvaluationUseCase {
  final IaBellaRepository repository;

  IaBellaFinalEvaluationUseCaseImpl({required this.repository});

  @override
  Future<Try<IaBellaFinalEvaluationEntity>> call(
      IaBellaFinalEvaluationUseCaseParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.finalEvaluation(
        params.condominiumId, params.messageEvaluation);
  }

  Failure? _validate(IaBellaFinalEvaluationUseCaseParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.messageEvaluation.uuidSession?.isEmpty ?? true)
      return InvalidParamFailure();
    if (param.messageEvaluation.evaluation == null ||
        param.messageEvaluation.evaluation! < 1 ||
        param.messageEvaluation.evaluation! > 5) return InvalidParamFailure();
    if (param.messageEvaluation.requestResolved == null)
      return InvalidParamFailure();
    return null;
  }
}
