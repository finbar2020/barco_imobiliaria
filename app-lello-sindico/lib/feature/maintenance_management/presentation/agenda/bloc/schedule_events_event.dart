import 'package:equatable/equatable.dart';
import '../../../domain/entity/filter_options_entity.dart';

abstract class ScheduleEventsEvent extends Equatable {
  const ScheduleEventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduleEventsEvent extends ScheduleEventsEvent {
  final DateTime selectedDate;
  final String? userToken;
  final String? sessionId;
  final FilterOptionsEntity? appliedFilters;
  final String? pageName;

  const LoadScheduleEventsEvent({
    required this.selectedDate,
    this.userToken,
    this.sessionId,
    this.appliedFilters,
    this.pageName,
  });

  @override
  List<Object?> get props =>
      [selectedDate, userToken, sessionId, appliedFilters, pageName];
}

class RefreshScheduleEventsEvent extends ScheduleEventsEvent {
  final DateTime selectedDate;
  final String? userToken;
  final String? sessionId;
  final FilterOptionsEntity? appliedFilters;

  const RefreshScheduleEventsEvent({
    required this.selectedDate,
    this.userToken,
    this.sessionId,
    this.appliedFilters,
  });

  @override
  List<Object?> get props =>
      [selectedDate, userToken, sessionId, appliedFilters];
}

class ResetScheduleEventEvent extends ScheduleEventsEvent {
  final String scheduleEventId;

  const ResetScheduleEventEvent({
    required this.scheduleEventId,
  });

  @override
  List<Object?> get props => [scheduleEventId];
}

class ClearScheduleEventsCacheEvent extends ScheduleEventsEvent {
  const ClearScheduleEventsCacheEvent();
}

class LoadScheduleEventsDetailEvent extends ScheduleEventsEvent {
  final DateTime dtStart;
  final DateTime untilDate;
  final DateTime dayCurrent;
  final String? userToken;
  final String? sessionId;

  const LoadScheduleEventsDetailEvent({
    required this.dtStart,
    required this.untilDate,
    required this.dayCurrent,
    this.userToken,
    this.sessionId,
  });

  @override
  List<Object?> get props =>
      [dtStart, untilDate, dayCurrent, userToken, sessionId];
}

class RefreshScheduleEventsDetailEvent extends ScheduleEventsEvent {
  final DateTime dtStart;
  final DateTime untilDate;
  final DateTime dayCurrent;
  final String? userToken;
  final String? sessionId;

  const RefreshScheduleEventsDetailEvent({
    required this.dtStart,
    required this.untilDate,
    required this.dayCurrent,
    this.userToken,
    this.sessionId,
  });

  @override
  List<Object?> get props =>
      [dtStart, untilDate, dayCurrent, userToken, sessionId];
}
