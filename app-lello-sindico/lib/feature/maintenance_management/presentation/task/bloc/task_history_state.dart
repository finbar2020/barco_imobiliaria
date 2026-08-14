import 'package:equatable/equatable.dart';
import '../../../domain/entity/schedule_event_history_entity.dart';

abstract class TaskHistoryState extends Equatable {
  const TaskHistoryState();

  @override
  List<Object?> get props => [];
}

class TaskHistoryInitialState extends TaskHistoryState {
  const TaskHistoryInitialState();
}

class TaskHistoryLoadingState extends TaskHistoryState {
  const TaskHistoryLoadingState();
}

class TaskHistoryLoadedState extends TaskHistoryState {
  final ScheduleEventHistoryEntity history;

  const TaskHistoryLoadedState(this.history);

  @override
  List<Object?> get props => [history];
}

class TaskHistoryErrorState extends TaskHistoryState {
  final String message;

  const TaskHistoryErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
