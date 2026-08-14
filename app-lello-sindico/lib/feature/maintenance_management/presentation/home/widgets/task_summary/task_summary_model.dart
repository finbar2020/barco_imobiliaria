import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TaskStatus {
  final TaskStatusType status;
  final int count;

  TaskStatus({
    required this.status,
    required this.count,
  });
}

class TaskSummaryData {
  final int totalTasks;
  final List<TaskStatus> statuses;

  TaskSummaryData({required this.totalTasks, required this.statuses});
}

enum TaskStatusType { pending, inProgress, completed }

extension TaskStatusTypeExtension on TaskStatusType {
  String name(BuildContext context) {
    switch (this) {
      case TaskStatusType.completed:
        return getString(context, "concluded");
      case TaskStatusType.pending:
        return getString(context, "pending");
      case TaskStatusType.inProgress:
        return getString(context, "task_status_in_progress");
    }
  }

  String statusLabel(BuildContext context) {
    switch (this) {
      case TaskStatusType.completed:
        return getString(context, "task_status_completed");
      case TaskStatusType.pending:
        return getString(context, "task_status_pending");
      case TaskStatusType.inProgress:
        return getString(context, "task_status_in_progress");
    }
  }

  Color color(ThemeData theme) {
    switch (this) {
      case TaskStatusType.completed:
        return LelloTheme.palleteOf(theme).success();
      case TaskStatusType.pending:
        return LelloTheme.palleteOf(theme).warning();
      case TaskStatusType.inProgress:
        return LelloTheme.palleteOf(theme).raffle();
    }
  }
}
