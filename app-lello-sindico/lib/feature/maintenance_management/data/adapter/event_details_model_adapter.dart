import '../../domain/entity/event_details_entity.dart';
import '../model/event_details_model.dart';

class EventDetailsModelAdapter {
  static EventDetailsEntity toEntity(EventDetailsModel model) {
    return EventDetailsEntity(
      id: model.id,
      lastContentAnswers: model.lastContentAnswers != null
          ? _toLastContentAnswersEntity(model.lastContentAnswers!)
          : null,
      parentScheduleEvent: model.parentScheduleEvent != null
          ? _toParentScheduleEventEntity(model.parentScheduleEvent!)
          : null,
    );
  }

  static LastContentAnswersEntity _toLastContentAnswersEntity(
      LastContentAnswersModel model) {
    return LastContentAnswersEntity(
      formularyId: model.formularyId,
      deletedAt: model.deletedAt,
      createdAt: model.createdAt,
      finishedAt: model.finishedAt,
      partnerId: model.partnerId,
      authorId: model.authorId,
      updatedAt: model.updatedAt,
      localId: model.localId,
      status: model.status,
      taskId: model.taskId,
      responsibleId: model.responsibleId,
      responsibleType: model.responsibleType,
      responsibleName: model.responsibleName,
      formulary: model.formulary != null 
          ? _toFormularyEntity(model.formulary!) 
          : null,
    );
  }

  static FormularyEntity _toFormularyEntity(FormularyModel model) {
    return FormularyEntity(
      id: model.id,
      name: model.name,
      position: model.position,
      procedureId: model.procedureId,
      enabled: model.enabled,
      description: model.description,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      questions: model.questions.map(_toQuestionEntity).toList(),
    );
  }

  static QuestionEntity _toQuestionEntity(QuestionModel model) {
    return QuestionEntity(
      id: model.id,
      name: model.name,
      position: model.position,
      formularyId: model.formularyId,
      hidden: model.hidden,
      required: model.required,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      fieldType: model.fieldType,
      options: model.options?.map(_toOptionEntity).toList(),
      expressions: model.expressions?.map(_toExpressionEntity).toList(),
    );
  }

  static OptionEntity _toOptionEntity(OptionModel model) {
    return OptionEntity(
      id: model.id,
      name: model.name,
      position: model.position,
      questionId: model.questionId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static ExpressionEntity _toExpressionEntity(ExpressionModel model) {
    return ExpressionEntity(
      id: model.id,
      factors: model.factors.map(_toFactorEntity).toList(),
    );
  }

  static FactorEntity _toFactorEntity(FactorModel model) {
    return FactorEntity(
      targetValue: model.targetValue,
      originId: model.originId,
      comparisonType: model.comparisonType,
    );
  }

  static ParentScheduleEventEntity _toParentScheduleEventEntity(
      ParentScheduleEventModel model) {
    return ParentScheduleEventEntity(
      id: model.id,
    );
  }
}
