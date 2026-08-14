import 'package:essentials/essentials.dart';

abstract class ScheduleEventsSummaryEvent extends Equatable {
  const ScheduleEventsSummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduleEventsSummaryEvent extends ScheduleEventsSummaryEvent {
  final DateTime selectedDate;

  const LoadScheduleEventsSummaryEvent({
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [selectedDate];
}

class ClearScheduleEventsSummaryCacheEvent extends ScheduleEventsSummaryEvent {
  const ClearScheduleEventsSummaryCacheEvent();
}