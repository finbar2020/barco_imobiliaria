import 'package:equatable/equatable.dart';

import '../../../../domain/entity/task_details_entity.dart';
import 'task_edit_state.dart';

abstract class TaskEditEvent extends Equatable {
  const TaskEditEvent();

  @override
  List<Object?> get props => [];
}

class TaskEditStarted extends TaskEditEvent {
  final TaskDetailsEntity task;

  const TaskEditStarted(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskEditToggleAllDay extends TaskEditEvent {
  final bool value;

  const TaskEditToggleAllDay(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditCheckInChanged extends TaskEditEvent {
  final String? value;

  const TaskEditCheckInChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditModeChanged extends TaskEditEvent {
  final TaskScheduleMode mode;

  const TaskEditModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}

class TaskEditReminderChanged extends TaskEditEvent {
  final String value;

  const TaskEditReminderChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditWeekDayToggled extends TaskEditEvent {
  final TaskWeekDay day;

  const TaskEditWeekDayToggled(this.day);

  @override
  List<Object?> get props => [day];
}

class TaskEditOrientationChanged extends TaskEditEvent {
  final String value;

  const TaskEditOrientationChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditSavePressed extends TaskEditEvent {
  const TaskEditSavePressed();
}

class TaskEditDiscardPressed extends TaskEditEvent {
  const TaskEditDiscardPressed();
}

class TaskEditDialogDismissed extends TaskEditEvent {
  const TaskEditDialogDismissed();
}

class TaskEditOutcomeCleared extends TaskEditEvent {
  const TaskEditOutcomeCleared();
}

class TaskEditScopeSelected extends TaskEditEvent {
  final TaskEditScope scope;

  const TaskEditScopeSelected(this.scope);

  @override
  List<Object?> get props => [scope];
}

class TaskEditConfirmScope extends TaskEditEvent {
  const TaskEditConfirmScope();
}

class TaskEditConfirmDiscard extends TaskEditEvent {
  const TaskEditConfirmDiscard();
}

class TaskEditStartDateChanged extends TaskEditEvent {
  final String date;

  const TaskEditStartDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class TaskEditEndDateChanged extends TaskEditEvent {
  final String date;

  const TaskEditEndDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}
