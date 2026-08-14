import 'package:equatable/equatable.dart';

import '../../../../domain/entity/task_details_entity.dart';

abstract class TaskInitStepEvent extends Equatable {
  const TaskInitStepEvent();

  @override
  List<Object?> get props => [];
}

class TaskInitStepStartedEvent extends TaskInitStepEvent {
  final String eventId;
  final TaskDetailsEntity task;
  final String taskId;

  const TaskInitStepStartedEvent(this.eventId, this.task, this.taskId);

  @override
  List<Object?> get props => [eventId, task, taskId];
}

class TaskInitStepSectorChangedEvent extends TaskInitStepEvent {
  final String? sector;

  const TaskInitStepSectorChangedEvent(this.sector);

  @override
  List<Object?> get props => [sector];
}

class TaskInitStepDescriptionChangedEvent extends TaskInitStepEvent {
  final String description;

  const TaskInitStepDescriptionChangedEvent(this.description);

  @override
  List<Object?> get props => [description];
}

class TaskInitStepPhotoAddedEvent extends TaskInitStepEvent {
  final String photoPath;

  const TaskInitStepPhotoAddedEvent(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

class TaskInitStepPhotoRemovedEvent extends TaskInitStepEvent {
  final String photoPath;

  const TaskInitStepPhotoRemovedEvent(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

class TaskInitStepSubmitPressedEvent extends TaskInitStepEvent {
  const TaskInitStepSubmitPressedEvent();
}

class TaskInitStepBackPressedEvent extends TaskInitStepEvent {
  const TaskInitStepBackPressedEvent();
}

class TaskInitStepConfirmDiscardEvent extends TaskInitStepEvent {
  const TaskInitStepConfirmDiscardEvent();
}

class TaskInitStepRequestResetEvent extends TaskInitStepEvent {
  const TaskInitStepRequestResetEvent();
}

class TaskInitStepConfirmResetEvent extends TaskInitStepEvent {
  const TaskInitStepConfirmResetEvent();
}

class TaskInitStepDialogDismissedEvent extends TaskInitStepEvent {
  const TaskInitStepDialogDismissedEvent();
}

class TaskInitStepStatusClearedEvent extends TaskInitStepEvent {
  const TaskInitStepStatusClearedEvent();
}

class TaskInitStepAnswerChangedEvent extends TaskInitStepEvent {
  final String questionId;
  final dynamic answer;

  const TaskInitStepAnswerChangedEvent({
    required this.questionId,
    required this.answer,
  });

  @override
  List<Object?> get props => [questionId, answer];
}
