import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_schedule_event_history_use_case.dart';
import '../../../domain/entity/schedule_event_history_entity.dart';

// Events
abstract class TaskHistoryEvent {}

class LoadTaskHistoryEvent extends TaskHistoryEvent {
  final String taskId;

  LoadTaskHistoryEvent(this.taskId);
}

// States
abstract class TaskHistoryState {}

class TaskHistoryInitialState extends TaskHistoryState {}

class TaskHistoryLoadingState extends TaskHistoryState {}

class TaskHistoryLoadedState extends TaskHistoryState {
  final ScheduleEventHistoryEntity history;

  TaskHistoryLoadedState(this.history);
}

class TaskHistoryErrorState extends TaskHistoryState {
  final String message;

  TaskHistoryErrorState(this.message);
}

// BLoC
class TaskHistoryBloc extends Bloc<TaskHistoryEvent, TaskHistoryState> {
  final GetScheduleEventHistoryUseCase _getScheduleEventHistoryUseCase;

  TaskHistoryBloc(this._getScheduleEventHistoryUseCase)
      : super(TaskHistoryInitialState()) {
    on<LoadTaskHistoryEvent>(_onLoadTaskHistory);
  }

  Future<void> _onLoadTaskHistory(
    LoadTaskHistoryEvent event,
    Emitter<TaskHistoryState> emit,
  ) async {
    emit(TaskHistoryLoadingState());

    try {
      if (event.taskId.isEmpty) {
        emit(TaskHistoryErrorState('ID da tarefa inválido'));
        return;
      }

      final result = await _getScheduleEventHistoryUseCase(event.taskId);

      result.fold(
        (failure) {
          emit(TaskHistoryErrorState(failure.toString()));
        },
        (history) {
          emit(TaskHistoryLoadedState(history));
        },
      );
    } catch (e) {
      emit(TaskHistoryErrorState('Erro ao carregar histórico da tarefa: $e'));
    }
  }
}
