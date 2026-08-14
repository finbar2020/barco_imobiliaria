import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_schedule_event_history_use_case.dart';
import 'task_history_event.dart';
import 'task_history_state.dart';

// Re-exportar para manter compatibilidade com quem importa apenas o bloc
export 'task_history_event.dart';
export 'task_history_state.dart';

class TaskHistoryBloc extends Bloc<TaskHistoryEvent, TaskHistoryState> {
  final GetScheduleEventHistoryUseCase _getScheduleEventHistoryUseCase;

  TaskHistoryBloc(this._getScheduleEventHistoryUseCase)
      : super(const TaskHistoryInitialState()) {
    on<LoadTaskHistoryEvent>(_onLoadTaskHistory);
  }

  Future<void> _onLoadTaskHistory(
    LoadTaskHistoryEvent event,
    Emitter<TaskHistoryState> emit,
  ) async {
    emit(const TaskHistoryLoadingState());

    try {
      if (event.taskId.isEmpty) {
        emit(const TaskHistoryErrorState('ID da tarefa inválido'));
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
