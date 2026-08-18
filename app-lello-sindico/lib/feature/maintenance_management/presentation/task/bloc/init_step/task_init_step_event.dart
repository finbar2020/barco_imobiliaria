import 'package:equatable/equatable.dart';

import '../../../../domain/entity/task_details_entity.dart';

abstract class TaskInitStepEvent extends Equatable {
  const TaskInitStepEvent();

  @override
  List<Object?> get props => [];
}

class TaskInitStepStarted extends TaskInitStepEvent {
  final String eventId;
  final TaskDetailsEntity task;
  final String taskId;

  const TaskInitStepStarted(this.eventId, this.task, this.taskId);

  @override
  List<Object?> get props => [eventId, task, taskId];
}

class TaskInitStepSectorChanged extends TaskInitStepEvent {
  final String? sector;

  const TaskInitStepSectorChanged(this.sector);

  @override
  List<Object?> get props => [sector];
}

class TaskInitStepDescriptionChanged extends TaskInitStepEvent {
  final String description;

  const TaskInitStepDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class TaskInitStepPhotoAdded extends TaskInitStepEvent {
  final String photoPath;

  const TaskInitStepPhotoAdded(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

class TaskInitStepPhotoRemoved extends TaskInitStepEvent {
  final String photoPath;

  const TaskInitStepPhotoRemoved(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

class TaskInitStepSubmitPressed extends TaskInitStepEvent {
  const TaskInitStepSubmitPressed();
}

class TaskInitStepBackPressed extends TaskInitStepEvent {
  const TaskInitStepBackPressed();
}

class TaskInitStepConfirmDiscard extends TaskInitStepEvent {
  const TaskInitStepConfirmDiscard();
}

class TaskInitStepRequestReset extends TaskInitStepEvent {
  const TaskInitStepRequestReset();
}

class TaskInitStepConfirmReset extends TaskInitStepEvent {
  const TaskInitStepConfirmReset();
}

class TaskInitStepDialogDismissed extends TaskInitStepEvent {
  const TaskInitStepDialogDismissed();
}

class TaskInitStepOutcomeCleared extends TaskInitStepEvent {
  const TaskInitStepOutcomeCleared();
}

class TaskInitStepAnswerChanged extends TaskInitStepEvent {
  final String questionId;
  final dynamic answer;

  const TaskInitStepAnswerChanged({
    required this.questionId,
    required this.answer,
  });

  @override
  List<Object?> get props => [questionId, answer];
}
