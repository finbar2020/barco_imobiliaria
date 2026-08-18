import 'package:equatable/equatable.dart';
import '../../../domain/entity/schedule_event_task_entity.dart';
import '../../../domain/entity/schedule_events_detail_response_entity.dart';
import '../../../domain/entity/efficiency_entity.dart';
import '../../../domain/entity/reset_schedule_event_entity.dart';

abstract class ScheduleEventsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScheduleEventsInitialState extends ScheduleEventsState {}

class ScheduleEventsLoadingState extends ScheduleEventsState {}

class ResetScheduleEventLoadingState extends ScheduleEventsState {}

class ResetScheduleEventSuccessState extends ScheduleEventsState {
  final ResetScheduleEventEntity resetResult;

  ResetScheduleEventSuccessState({required this.resetResult});

  @override
  List<Object?> get props => [resetResult];

  @override
  String toString() {
    return 'ResetScheduleEventSuccessState(success: ${resetResult.success}, message: ${resetResult.message})';
  }
}

class ResetScheduleEventErrorState extends ScheduleEventsState {
  final String message;

  ResetScheduleEventErrorState({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return 'ResetScheduleEventErrorState(message: $message)';
  }
}

class ScheduleEventsLoadedState extends ScheduleEventsState {
  final List<ScheduleEventTaskEntity> events;
  final List<ScheduleEventObligationEntity> obligations;
  final TaskSummaryEntity? taskSummary;
  final DateTime selectedDate;

  ScheduleEventsLoadedState({
    required this.events,
    this.obligations = const [],
    this.taskSummary,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [events, obligations, taskSummary, selectedDate];

  @override
  String toString() {
    return 'ScheduleEventsLoadedState(events: ${events.length}, obligations: ${obligations.length}, date: $selectedDate)';
  }
}

class ScheduleEventsErrorState extends ScheduleEventsState {
  final String message;

  ScheduleEventsErrorState({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return 'ScheduleEventsErrorState(message: $message)';
  }
}

class ScheduleEventsEmptyState extends ScheduleEventsState {
  final DateTime selectedDate;

  ScheduleEventsEmptyState({required this.selectedDate});

  @override
  List<Object?> get props => [selectedDate];

  @override
  String toString() {
    return 'ScheduleEventsEmptyState(date: $selectedDate)';
  }
}

class ScheduleEventsDetailLoadedState extends ScheduleEventsState {
  final ScheduleEventsDetailResponseEntity detailResponse;
  final DateTime dtStart;
  final DateTime untilDate;
  final DateTime dayCurrent;

  ScheduleEventsDetailLoadedState({
    required this.detailResponse,
    required this.dtStart,
    required this.untilDate,
    required this.dayCurrent,
  });

  @override
  List<Object?> get props => [detailResponse, dtStart, untilDate, dayCurrent];

  @override
  String toString() {
    return 'ScheduleEventsDetailLoadedState(days: ${detailResponse.data.taskSummaryDay.length})';
  }
}

class ScheduleEventsDetailEmptyState extends ScheduleEventsState {
  final DateTime dtStart;
  final DateTime untilDate;
  final DateTime dayCurrent;

  ScheduleEventsDetailEmptyState({
    required this.dtStart,
    required this.untilDate,
    required this.dayCurrent,
  });

  @override
  List<Object?> get props => [dtStart, untilDate, dayCurrent];

  @override
  String toString() {
    return 'ScheduleEventsDetailEmptyState(period: $dtStart to $untilDate)';
  }
}
