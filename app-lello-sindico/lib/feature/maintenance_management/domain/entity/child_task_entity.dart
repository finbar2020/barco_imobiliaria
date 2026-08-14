import 'origin_answer_entity.dart';

class ChildTaskEntity {
  final String? scheduleEventId;
  final OriginAnswerEntity? originAnswer;

  ChildTaskEntity({
    this.scheduleEventId,
    this.originAnswer,
  });
}
