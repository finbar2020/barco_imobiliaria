import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_final_evaluation_entity.dart';

abstract class IaBellaFinalEvaluationUseCase extends UseCase<
    IaBellaFinalEvaluationEntity, IaBellaFinalEvaluationUseCaseParam> {}

class IaBellaFinalEvaluationUseCaseParam {
  final String condominiumId;
  IaBellaFinalEvaluationModel messageEvaluation;

  IaBellaFinalEvaluationUseCaseParam(
      {required this.condominiumId, required this.messageEvaluation});
}
