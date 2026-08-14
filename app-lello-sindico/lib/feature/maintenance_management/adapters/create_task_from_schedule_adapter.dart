import '../data/model/create_task_from_schedule_request_model.dart';
import '../data/model/create_task_from_schedule_response_model.dart';
import '../domain/entity/create_task_from_schedule_entity.dart';

class CreateTaskFromScheduleAdapter {
  static CreateTaskFromScheduleRequestModel toModel(
      CreateTaskFromScheduleRequestEntity entity) {
    return CreateTaskFromScheduleRequestModel(
      scheduleId: entity.scheduleId,
      scheduleEventId: entity.scheduleEventId,
    );
  }

  static CreateTaskFromScheduleResponseEntity toEntity(
      CreateTaskFromScheduleResponseModel model) {
    return CreateTaskFromScheduleResponseEntity(
      task: _mapTask(model.task),
      event: _mapEvent(model.event),
    );
  }

  static TaskCreatedEntity _mapTask(TaskCreatedModel model) {
    return TaskCreatedEntity(
      id: model.id,
      name: model.name,
      currentResponsibleName: model.currentResponsibleName,
      currentResponsibleId: model.currentResponsibleId,
    );
  }

  static EventCreatedEntity _mapEvent(EventCreatedModel model) {
    return EventCreatedEntity(
      id: model.id,
      name: model.name,
      lastContentAnswers: model.lastContentAnswers != null
          ? _mapLastContentAnswers(model.lastContentAnswers!)
          : null,
    );
  }

  static LastContentAnswersEntity _mapLastContentAnswers(
      LastContentAnswersModel model) {
    return LastContentAnswersEntity(
      questionId: model.questionId,
      type: model.type,
      content: model.content,
      updatedAt: model.updatedAt,
      formularyId: model.formularyId,
      deletedAt: model.deletedAt,
    );
  }
}
