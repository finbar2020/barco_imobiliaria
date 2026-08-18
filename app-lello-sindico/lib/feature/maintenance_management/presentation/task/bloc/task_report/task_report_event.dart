abstract class TaskReportEvent {}

class LoadTaskReport extends TaskReportEvent {
  final String eventId;

  LoadTaskReport({required this.eventId});
}

class RefreshTaskReport extends TaskReportEvent {
  final String eventId;

  RefreshTaskReport({required this.eventId});
}
