import 'package:equatable/equatable.dart';

abstract class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskDetailsEvent extends TaskDetailsEvent {
  final String taskId;

  const LoadTaskDetailsEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ChangeTabEvent extends TaskDetailsEvent {
  final TaskDetailsTabType tabType;

  const ChangeTabEvent(this.tabType);

  @override
  List<Object?> get props => [tabType];
}

class CreateTaskFromScheduleEvent extends TaskDetailsEvent {
  final String scheduleId;
  final String scheduleEventId;

  const CreateTaskFromScheduleEvent({
    required this.scheduleId,
    required this.scheduleEventId,
  });

  @override
  List<Object?> get props => [scheduleId, scheduleEventId];
}

enum TaskDetailsTabType { steps, attachments }
