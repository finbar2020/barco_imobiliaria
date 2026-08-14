import 'package:equatable/equatable.dart';

import '../../../../../domain/entity/efficiency_entity.dart';

abstract class TaskSummaryState extends Equatable {
  const TaskSummaryState();

  @override
  List<Object?> get props => [];
}

class TaskSummaryInitialState extends TaskSummaryState {
  const TaskSummaryInitialState();
}

class TaskSummaryLoadingState extends TaskSummaryState {
  const TaskSummaryLoadingState();
}

class TaskSummaryLoadedState extends TaskSummaryState {
  final TaskSummaryEntity taskSummary;

  const TaskSummaryLoadedState({required this.taskSummary});

  @override
  List<Object?> get props => [taskSummary];
}

class TaskSummaryErrorState extends TaskSummaryState {
  final String message;

  const TaskSummaryErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
