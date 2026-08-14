import 'package:equatable/equatable.dart';
import '../../../../domain/entity/task_report_entity.dart';

abstract class TaskReportState extends Equatable {
  const TaskReportState();

  @override
  List<Object?> get props => [];
}

class TaskReportInitialState extends TaskReportState {
  const TaskReportInitialState();
}

class TaskReportLoadingState extends TaskReportState {
  const TaskReportLoadingState();
}

class TaskReportLoadedState extends TaskReportState {
  final TaskReportEntity report;

  const TaskReportLoadedState({required this.report});

  @override
  List<Object?> get props => [report];
}

class TaskReportErrorState extends TaskReportState {
  final String message;

  const TaskReportErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
