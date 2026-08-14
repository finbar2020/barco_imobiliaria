class CreateTaskFromScheduleRequestEntity {
  final String scheduleId;
  final String scheduleEventId;

  CreateTaskFromScheduleRequestEntity({
    required this.scheduleId,
    required this.scheduleEventId,
  });
}

class CreateTaskFromScheduleResponseEntity {
  final TaskCreatedEntity task;
  final EventCreatedEntity event;

  CreateTaskFromScheduleResponseEntity({
    required this.task,
    required this.event,
  });
}

class TaskCreatedEntity {
  final String id;
  final String name;
  final String? currentResponsibleName;
  final String? currentResponsibleId;

  TaskCreatedEntity({
    required this.id,
    required this.name,
    this.currentResponsibleName,
    this.currentResponsibleId,
  });
}

class EventCreatedEntity {
  final String id;
  final String? name;
  final LastContentAnswersEntity? lastContentAnswers;

  EventCreatedEntity({
    required this.id,
    this.name,
    this.lastContentAnswers,
  });
}

class LastContentAnswersEntity {
  final String questionId;
  final String type;
  final String content;
  final String updatedAt;
  final String formularyId;
  final String? deletedAt;

  LastContentAnswersEntity({
    required this.questionId,
    required this.type,
    required this.content,
    required this.updatedAt,
    required this.formularyId,
    this.deletedAt,
  });
}
