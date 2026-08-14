import 'package:equatable/equatable.dart';

abstract class TaskHistoryEvent extends Equatable {
  const TaskHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskHistoryEvent extends TaskHistoryEvent {
  final String taskId;

  const LoadTaskHistoryEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
