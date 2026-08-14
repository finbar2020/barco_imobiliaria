import 'origin_answer_entity.dart';

class TaskReportEntity {
  final String id;
  final String taskId;
  final String stepName;
  final String responsibleName;
  final String status;
  final String? completedAt;
  final String? createdAt;
  final String? finishedAt;
  final String formularName;
  final List<TaskReportQuestionEntity> questions;
  final List<ChildTaskEntity>? childTasks;

  TaskReportEntity({
    required this.id,
    required this.taskId,
    required this.stepName,
    required this.responsibleName,
    required this.status,
    this.completedAt,
    this.createdAt,
    this.finishedAt,
    required this.formularName,
    required this.questions,
    this.childTasks,
  });
}

class TaskReportQuestionEntity {
  final String id;
  final String question;
  final TaskReportQuestionType type;
  final TaskReportAnswerEntity? answer;
  final List<String>? options; // Para SELECT e RADIO
  final bool isRequired;
  final List<TaskReportAnswerEntity>?
      dependentFileAnswers; // Respostas de FILE dependentes deste campo

  TaskReportQuestionEntity({
    required this.id,
    required this.question,
    required this.type,
    this.answer,
    this.options,
    this.isRequired = false,
    this.dependentFileAnswers,
  });
}

class TaskReportAnswerEntity {
  final String id;
  final String questionId;
  final TaskReportAnswerType type;
  final String? textValue;
  final String? selectedOption;
  final List<String>? selectedOptions;
  final List<TaskReportFileEntity>? files;
  final String? answeredAt;
  final String? questionName; // Nome da pergunta (para dependentes)

  TaskReportAnswerEntity({
    required this.id,
    required this.questionId,
    required this.type,
    this.textValue,
    this.selectedOption,
    this.selectedOptions,
    this.files,
    this.answeredAt,
    this.questionName,
  });
}

class TaskReportFileEntity {
  final String id;
  final String url;
  final String filename;
  final String extension;
  final int sizeInBytes;
  final String? uploadedAt;

  TaskReportFileEntity({
    required this.id,
    required this.url,
    required this.filename,
    required this.extension,
    required this.sizeInBytes,
    this.uploadedAt,
  });
}

enum TaskReportQuestionType {
  textarea,
  radio,
  select,
  file,
}

enum TaskReportAnswerType {
  text,
  singleChoice,
  multipleChoice,
  file,
}

class ChildTaskEntity {
  final String? scheduleEventId;
  final OriginAnswerEntity? originAnswer;

  ChildTaskEntity({
    this.scheduleEventId,
    this.originAnswer,
  });
}
