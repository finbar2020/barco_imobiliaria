class OriginAnswerEntity {
  final String? id;
  final String? eventId;
  final String? questionId;

  OriginAnswerEntity({
    this.id,
    this.eventId,
    this.questionId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OriginAnswerEntity &&
        other.id == id &&
        other.eventId == eventId &&
        other.questionId == questionId;
  }

  @override
  int get hashCode => id.hashCode ^ eventId.hashCode ^ questionId.hashCode;
}
