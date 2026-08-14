class IaBellaRateResponseEntity {
  final String? responseId;
  final String? evaluationType;
  final String? justification;

  IaBellaRateResponseEntity({
    this.responseId,
    this.evaluationType,
    this.justification,
  });

  IaBellaRateResponseEntity copyWith({
    String? responseId,
    String? evaluationType,
    String? justification,
  }) {
    return IaBellaRateResponseEntity(
      responseId: responseId ?? this.responseId,
      evaluationType: evaluationType ?? this.evaluationType,
      justification: justification ?? this.justification,
    );
  }
}
