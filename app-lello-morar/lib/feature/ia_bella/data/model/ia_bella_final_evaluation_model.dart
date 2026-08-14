import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_final_evaluation_entity.dart';

part 'ia_bella_final_evaluation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaBellaFinalEvaluationModel {
  final String? uuidSession;
  final int? evaluation;
  final String? comment;
  final bool? requestResolved;

  IaBellaFinalEvaluationModel({
    this.uuidSession,
    this.evaluation,
    this.comment,
    this.requestResolved,
  });

  factory IaBellaFinalEvaluationModel.fromJson(Map<String, dynamic> json) =>
      _$IaBellaFinalEvaluationModelFromJson(json);

  Map<String, dynamic> toJson() => _$IaBellaFinalEvaluationModelToJson(this);

  static IaBellaFinalEvaluationModel? fromEntity(
          IaBellaFinalEvaluationEntity? entity) =>
      entity == null
          ? null
          : IaBellaFinalEvaluationModel(
              uuidSession: entity.uuidSession,
              evaluation: entity.evaluation,
              comment: entity.comment,
              requestResolved: entity.requestResolved,
            );

  IaBellaFinalEvaluationEntity toEntity() => IaBellaFinalEvaluationEntity(
        uuidSession: uuidSession,
        evaluation: evaluation,
        comment: comment,
        requestResolved: requestResolved,
      );
}
