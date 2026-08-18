abstract class TaskSummaryEvent {}

class LoadTaskSummaryEvent extends TaskSummaryEvent {
  final String dtStart;
  final String untilDate;

  LoadTaskSummaryEvent({
    required this.dtStart,
    required this.untilDate,
  });
}

class ClearTaskSummaryCacheEvent extends TaskSummaryEvent {}
