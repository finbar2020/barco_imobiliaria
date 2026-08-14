import '../model/origin_answer_model.dart';
import '../../domain/entity/origin_answer_entity.dart';

extension OriginAnswerModelExtension on OriginAnswerModel {
  OriginAnswerEntity toEntity() {
    return OriginAnswerEntity(
      id: id,
      eventId: eventId,
      questionId: questionId,
    );
  }
}

extension OriginAnswerEntityExtension on OriginAnswerEntity {
  OriginAnswerModel toModel() {
    return OriginAnswerModel(
      id: id,
      eventId: eventId,
      questionId: questionId,
    );
  }
}
