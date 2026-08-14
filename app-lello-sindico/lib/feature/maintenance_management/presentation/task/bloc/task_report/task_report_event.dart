import 'package:equatable/equatable.dart';

abstract class TaskReportEvent extends Equatable {
  const TaskReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskReportEvent extends TaskReportEvent {
  final String eventId;

  const LoadTaskReportEvent({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class RefreshTaskReportEvent extends TaskReportEvent {
  final String eventId;

  const RefreshTaskReportEvent({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}
