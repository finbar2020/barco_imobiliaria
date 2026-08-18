abstract class TaskDetailsEvent {
  const TaskDetailsEvent();
}

class LoadTaskDetailsEvent extends TaskDetailsEvent {
  final String taskId;

  const LoadTaskDetailsEvent(this.taskId);
}

class ChangeTabEvent extends TaskDetailsEvent {
  final TaskDetailsTabType tabType;

  const ChangeTabEvent(this.tabType);
}

class CreateTaskFromScheduleEvent extends TaskDetailsEvent {
  final String scheduleId;
  final String scheduleEventId;

  const CreateTaskFromScheduleEvent({
    required this.scheduleId,
    required this.scheduleEventId,
  });
}

enum TaskDetailsTabType { steps, attachments }
