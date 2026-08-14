import 'package:equatable/equatable.dart';

import '../../../../domain/entity/event_details_entity.dart';
import '../../../../domain/entity/task_details_entity.dart';

enum TaskInitStepDialogType { none, discard, reset }

enum TaskInitStepStatus { success, discarded, error, reset }

class TaskInitStepState extends Equatable {
  final String eventId;
  final String taskId;
  final TaskDetailsEntity? task;
  final FormularyEntity? formulary;
  final List<QuestionEntity> questions;
  final Map<String, dynamic> answers; // questionId -> answer
  final bool isLoading;
  final bool isSubmitting;
  final TaskInitStepDialogType dialog;
  final TaskInitStepStatus? outcome;
  final String? errorMessage;

  const TaskInitStepState({
    required this.eventId,
    required this.taskId,
    this.task,
    this.formulary,
    this.questions = const [],
    this.answers = const {},
    this.isLoading = false,
    this.isSubmitting = false,
    this.dialog = TaskInitStepDialogType.none,
    this.outcome,
    this.errorMessage,
  });

  bool get isFormValid {
    // Valida se todas as questions obrigatórias foram respondidas
    for (final question in questions) {
      if (question.required && !question.hidden) {
        final answer = answers[question.id];
        if (answer == null || _isAnswerEmpty(answer)) {
          return false;
        }
      }
    }
    return true;
  }

  bool _isAnswerEmpty(dynamic answer) {
    if (answer is String) return answer.isEmpty;
    if (answer is List) return answer.isEmpty;
    if (answer is Map) return answer.isEmpty;
    return false;
  }

  TaskInitStepState copyWith({
    String? eventId,
    String? taskId,
    TaskDetailsEntity? task,
    FormularyEntity? formulary,
    List<QuestionEntity>? questions,
    Map<String, dynamic>? answers,
    bool? isLoading,
    bool? isSubmitting,
    TaskInitStepDialogType? dialog,
    TaskInitStepStatus? outcome,
    String? errorMessage,
  }) {
    return TaskInitStepState(
      eventId: eventId ?? this.eventId,
      taskId: taskId ?? this.taskId,
      task: task ?? this.task,
      formulary: formulary ?? this.formulary,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      dialog: dialog ?? this.dialog,
      outcome: outcome,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        eventId,
        taskId,
        task,
        formulary,
        questions,
        answers,
        isLoading,
        isSubmitting,
        dialog,
        outcome,
        errorMessage,
      ];
}
