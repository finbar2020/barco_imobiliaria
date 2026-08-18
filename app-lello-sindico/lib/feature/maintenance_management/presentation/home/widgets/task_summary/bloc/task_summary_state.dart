import '../../../../../domain/entity/efficiency_entity.dart';

abstract class TaskSummaryState {}

class TaskSummaryInitialState extends TaskSummaryState {}

class TaskSummaryLoadingState extends TaskSummaryState {}

class TaskSummaryLoadedState extends TaskSummaryState {
  final TaskSummaryEntity taskSummary;

  TaskSummaryLoadedState({required this.taskSummary});
}

class TaskSummaryErrorState extends TaskSummaryState {
  final String message;

  TaskSummaryErrorState({required this.message});
}
