import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ScheduleEventStatus {
  final ScheduleEventStatusType status;
  final int count;

  ScheduleEventStatus({
    required this.status,
    required this.count,
  });
}

class ScheduleEventsSummaryData {
  final int totalEvents;
  final List<ScheduleEventStatus> statuses;

  ScheduleEventsSummaryData({
    required this.totalEvents, 
    required this.statuses,
  });
}

enum ScheduleEventStatusType { notStarted, draft, done }

extension ScheduleEventStatusTypeExtension on ScheduleEventStatusType {
  String name(BuildContext context) {
    switch (this) {
      case ScheduleEventStatusType.done:
        return getString(context, "concluded");
      case ScheduleEventStatusType.notStarted:
        return getString(context, "not_started");
      case ScheduleEventStatusType.draft:
        return getString(context, "task_status_in_progress");
    }
  }

  String statusLabel(BuildContext context) {
    switch (this) {
      case ScheduleEventStatusType.done:
        return getString(context, "task_status_completed");
      case ScheduleEventStatusType.notStarted:
        return getString(context, "task_status_pending");
      case ScheduleEventStatusType.draft:
        return getString(context, "task_status_in_progress");
    }
  }

  Color color(ThemeData theme) {
    switch (this) {
      case ScheduleEventStatusType.done:
        return LelloTheme.palleteOf(theme).success();
      case ScheduleEventStatusType.notStarted:
        return LelloTheme.palleteOf(theme).warning();
      case ScheduleEventStatusType.draft:
        return LelloTheme.palleteOf(theme).raffle();
    }
  }
}