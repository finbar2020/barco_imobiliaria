import '../../../../domain/entity/task_report_entity.dart';

abstract class TaskReportState {}

class TaskReportInitial extends TaskReportState {}

class TaskReportLoading extends TaskReportState {}

class TaskReportLoaded extends TaskReportState {
  final TaskReportEntity report;

  TaskReportLoaded({required this.report});
}

class TaskReportError extends TaskReportState {
  final String message;

  TaskReportError({required this.message});
}
