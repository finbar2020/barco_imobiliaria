import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/use_cases/get_task_report_use_case.dart';
import 'task_report_event.dart';
import 'task_report_state.dart';

class TaskReportBloc extends Bloc<TaskReportEvent, TaskReportState> {
  final GetTaskReportUseCase _getTaskReportUseCase;

  TaskReportBloc({
    required GetTaskReportUseCase getTaskReportUseCase,
  })  : _getTaskReportUseCase = getTaskReportUseCase,
        super(const TaskReportInitialState()) {
    on<LoadTaskReportEvent>(_onLoadTaskReport);
    on<RefreshTaskReportEvent>(_onRefreshTaskReport);
  }

  Future<void> _onLoadTaskReport(
    LoadTaskReportEvent event,
    Emitter<TaskReportState> emit,
  ) async {
    emit(const TaskReportLoadingState());

    try {
      final result = await _getTaskReportUseCase(event.eventId);
      result.fold(
        (failure) => emit(TaskReportErrorState(message: failure.toString())),
        (report) => emit(TaskReportLoadedState(report: report)),
      );
    } catch (e) {
      emit(TaskReportErrorState(message: e.toString()));
    }
  }

  Future<void> _onRefreshTaskReport(
    RefreshTaskReportEvent event,
    Emitter<TaskReportState> emit,
  ) async {
    // Mantém o estado atual durante o refresh se já tem dados
    final currentState = state;
    if (currentState is! TaskReportLoadedState) {
      emit(const TaskReportLoadingState());
    }

    try {
      final result = await _getTaskReportUseCase(event.eventId);
      result.fold(
        (failure) {
          // Se já tinha dados carregados, volta ao estado anterior em caso de erro
          if (currentState is TaskReportLoadedState) {
            emit(currentState);
          } else {
            emit(TaskReportErrorState(message: failure.toString()));
          }
        },
        (report) => emit(TaskReportLoadedState(report: report)),
      );
    } catch (e) {
      // Se já tinha dados carregados, volta ao estado anterior em caso de erro
      if (currentState is TaskReportLoadedState) {
        emit(currentState);
      } else {
        emit(TaskReportErrorState(message: e.toString()));
      }
    }
  }
}
