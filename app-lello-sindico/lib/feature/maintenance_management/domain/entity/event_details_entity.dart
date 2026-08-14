class EventDetailsEntity {
  final String id;
  final LastContentAnswersEntity? lastContentAnswers;
  final ParentScheduleEventEntity? parentScheduleEvent;

  EventDetailsEntity({
    required this.id,
    this.lastContentAnswers,
    this.parentScheduleEvent,
  });
}

class LastContentAnswersEntity {
  final String formularyId;
  final String? deletedAt;
  final String createdAt;
  final String? finishedAt;
  final String? partnerId;
  final String? authorId;
  final String updatedAt;
  final String? localId;
  final String status;
  final String taskId;
  final String? responsibleId;
  final String? responsibleType;
  final String? responsibleName;
  final FormularyEntity? formulary; // Nullable - pode vir null da API

  LastContentAnswersEntity({
    required this.formularyId,
    this.deletedAt,
    required this.createdAt,
    this.finishedAt,
    this.partnerId,
    this.authorId,
    required this.updatedAt,
    this.localId,
    required this.status,
    required this.taskId,
    this.responsibleId,
    this.responsibleType,
    this.responsibleName,
    this.formulary, // Nullable
  });
}

class FormularyEntity {
  final String id;
  final String name;
  final int position;
  final String procedureId;
  final bool enabled;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final List<QuestionEntity> questions;

  FormularyEntity({
    required this.id,
    required this.name,
    required this.position,
    required this.procedureId,
    required this.enabled,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });
}

class QuestionEntity {
  final String id;
  final String name;
  final int position;
  final String formularyId;
  final bool hidden;
  final bool required;
  final String createdAt;
  final String updatedAt;
  final String fieldType;
  final List<OptionEntity>? options;
  final List<ExpressionEntity>? expressions;

  QuestionEntity({
    required this.id,
    required this.name,
    required this.position,
    required this.formularyId,
    required this.hidden,
    required this.required,
    required this.createdAt,
    required this.updatedAt,
    required this.fieldType,
    this.options,
    this.expressions,
  });
}

class OptionEntity {
  final String id;
  final String name;
  final int position;
  final String questionId;
  final String createdAt;
  final String updatedAt;

  OptionEntity({
    required this.id,
    required this.name,
    required this.position,
    required this.questionId,
    required this.createdAt,
    required this.updatedAt,
  });
}

class ExpressionEntity {
  final String id;
  final List<FactorEntity> factors;

  ExpressionEntity({
    required this.id,
    required this.factors,
  });
}

class FactorEntity {
  final String targetValue;
  final String originId;
  final String comparisonType;

  FactorEntity({
    required this.targetValue,
    required this.originId,
    required this.comparisonType,
  });
}

class ParentScheduleEventEntity {
  final String id;

  ParentScheduleEventEntity({
    required this.id,
  });
}
