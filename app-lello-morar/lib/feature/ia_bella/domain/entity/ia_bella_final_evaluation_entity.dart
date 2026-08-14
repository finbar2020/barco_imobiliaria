class IaBellaFinalEvaluationEntity {
  final String? uuidSession;
  final int? evaluation;
  final String? comment;
  final bool? requestResolved;

  IaBellaFinalEvaluationEntity({
    this.uuidSession,
    this.evaluation,
    this.comment,
    this.requestResolved,
  });

  IaBellaFinalEvaluationEntity copyWith({
    String? uuidSession,
    int? evaluation,
    String? comment,
    bool? requestResolved,
  }) {
    return IaBellaFinalEvaluationEntity(
      uuidSession: uuidSession ?? this.uuidSession,
      evaluation: evaluation ?? this.evaluation,
      comment: comment ?? this.comment,
      requestResolved: requestResolved ?? this.requestResolved,
    );
  }
}
