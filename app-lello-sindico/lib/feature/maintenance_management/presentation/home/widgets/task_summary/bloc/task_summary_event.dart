import 'package:equatable/equatable.dart';

abstract class TaskSummaryEvent extends Equatable {
  const TaskSummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskSummaryEvent extends TaskSummaryEvent {
  final String dtStart;
  final String untilDate;

  const LoadTaskSummaryEvent({
    required this.dtStart,
    required this.untilDate,
  });

  @override
  List<Object?> get props => [dtStart, untilDate];
}

class ClearTaskSummaryCacheEvent extends TaskSummaryEvent {
  const ClearTaskSummaryCacheEvent();
}
