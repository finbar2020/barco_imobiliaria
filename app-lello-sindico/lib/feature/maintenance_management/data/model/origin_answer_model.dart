class OriginAnswerModel {
  final String? id;
  final String? eventId;
  final String? questionId;

  OriginAnswerModel({
    this.id,
    this.eventId,
    this.questionId,
  });

  factory OriginAnswerModel.fromJson(Map<String, dynamic> json) {
    return OriginAnswerModel(
      id: json['id'] as String?,
      eventId: json['event_id'] as String?,
      questionId: json['question_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'question_id': questionId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OriginAnswerModel &&
        other.id == id &&
        other.eventId == eventId &&
        other.questionId == questionId;
  }

  @override
  int get hashCode => id.hashCode ^ eventId.hashCode ^ questionId.hashCode;
}
