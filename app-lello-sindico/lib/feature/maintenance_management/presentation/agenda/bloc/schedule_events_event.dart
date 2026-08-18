import '../../../domain/entity/filter_options_entity.dart';

abstract class ScheduleEventsEvent {}

class LoadScheduleEventsEvent extends ScheduleEventsEvent {
  final DateTime selectedDate;
  final String? userToken;
  final String? sessionId;
  final FilterOptionsEntity? appliedFilters;
  final String? pageName;

  LoadScheduleEventsEvent({
    required this.selectedDate,
    this.userToken,
    this.sessionId,
    this.appliedFilters,
    this.pageName,
  });
}

class RefreshScheduleEventsEvent extends ScheduleEventsEvent {
  final DateTime selectedDate;
  final String? userToken;
  final String? sessionId;
  final FilterOptionsEntity? appliedFilters;

  RefreshScheduleEventsEvent({
    required this.selectedDate,
    this.userToken,
    this.sessionId,
    this.appliedFilters,
  });
}

class ResetScheduleEventEvent extends ScheduleEventsEvent {
  final String scheduleEventId;

  ResetScheduleEventEvent({
    required this.scheduleEventId,
  });
}

class ClearScheduleEventsCacheEvent extends ScheduleEventsEvent {}

class LoadScheduleEventsDetailEvent extends ScheduleEventsEvent {
  final DateTime dtStart;
  final DateTime untilDate;
  final DateTime dayCurrent;
  final String? userToken;
  final String? sessionId;

  LoadScheduleEventsDetailEvent({
    required this.dtStart,
    required this.untilDate,
    required this.dayCurrent,
    this.userToken,
    this.sessionId,
  });
}

class RefreshScheduleEventsDetailEvent extends ScheduleEventsEvent {
  final DateTime dtStart;
  final DateTime untilDate;
  final DateTime dayCurrent;
  final String? userToken;
  final String? sessionId;

  RefreshScheduleEventsDetailEvent({
    required this.dtStart,
    required this.untilDate,
    required this.dayCurrent,
    this.userToken,
    this.sessionId,
  });
}
