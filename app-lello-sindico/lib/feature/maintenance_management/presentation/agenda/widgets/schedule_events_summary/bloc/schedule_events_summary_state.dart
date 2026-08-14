import 'package:essentials/essentials.dart';
import '../../../../../domain/entity/efficiency_entity.dart';

abstract class ScheduleEventsSummaryState extends Equatable {
  const ScheduleEventsSummaryState();

  @override
  List<Object?> get props => [];
}

class ScheduleEventsSummaryInitialState extends ScheduleEventsSummaryState {}

class ScheduleEventsSummaryLoadingState extends ScheduleEventsSummaryState {}

class ScheduleEventsSummaryLoadedState extends ScheduleEventsSummaryState {
  final TaskSummaryEntity taskSummary;
  final DateTime selectedDate;

  const ScheduleEventsSummaryLoadedState({
    required this.taskSummary,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [taskSummary, selectedDate];
}

class ScheduleEventsSummaryErrorState extends ScheduleEventsSummaryState {
  final String message;

  const ScheduleEventsSummaryErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}