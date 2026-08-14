import 'package:equatable/equatable.dart';

import '../../../../domain/entity/task_details_entity.dart';
import 'task_edit_state.dart';

abstract class TaskEditEvent extends Equatable {
  const TaskEditEvent();

  @override
  List<Object?> get props => [];
}

class TaskEditStartedEvent extends TaskEditEvent {
  final TaskDetailsEntity task;

  const TaskEditStartedEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskEditToggleAllDayEvent extends TaskEditEvent {
  final bool value;

  const TaskEditToggleAllDayEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditCheckInChangedEvent extends TaskEditEvent {
  final String? value;

  const TaskEditCheckInChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditModeChangedEvent extends TaskEditEvent {
  final TaskScheduleMode mode;

  const TaskEditModeChangedEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

class TaskEditReminderChangedEvent extends TaskEditEvent {
  final String value;

  const TaskEditReminderChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditWeekDayToggledEvent extends TaskEditEvent {
  final TaskWeekDay day;

  const TaskEditWeekDayToggledEvent(this.day);

  @override
  List<Object?> get props => [day];
}

class TaskEditOrientationChangedEvent extends TaskEditEvent {
  final String value;

  const TaskEditOrientationChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class TaskEditSavePressedEvent extends TaskEditEvent {
  const TaskEditSavePressedEvent();
}

class TaskEditDiscardPressedEvent extends TaskEditEvent {
  const TaskEditDiscardPressedEvent();
}

class TaskEditDialogDismissedEvent extends TaskEditEvent {
  const TaskEditDialogDismissedEvent();
}

class TaskEditStatusClearedEvent extends TaskEditEvent {
  const TaskEditStatusClearedEvent();
}

class TaskEditScopeSelectedEvent extends TaskEditEvent {
  final TaskEditScope scope;

  const TaskEditScopeSelectedEvent(this.scope);

  @override
  List<Object?> get props => [scope];
}

class TaskEditConfirmScopeEvent extends TaskEditEvent {
  const TaskEditConfirmScopeEvent();
}

class TaskEditConfirmDiscardEvent extends TaskEditEvent {
  const TaskEditConfirmDiscardEvent();
}

class TaskEditStartDateChangedEvent extends TaskEditEvent {
  final String date;

  const TaskEditStartDateChangedEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class TaskEditEndDateChangedEvent extends TaskEditEvent {
  final String date;

  const TaskEditEndDateChangedEvent(this.date);

  @override
  List<Object?> get props => [date];
}
