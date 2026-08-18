import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/use_cases/get_task_report_use_case.dart';
import 'task_report_event.dart';
import 'task_report_state.dart';

class TaskReportBloc extends Bloc<TaskReportEvent, TaskReportState> {
  final GetTaskReportUseCase _getTaskReportUseCase;

  TaskReportBloc({
    required GetTaskReportUseCase getTaskReportUseCase,
  })  : _getTaskReportUseCase = getTaskReportUseCase,
        super(TaskReportInitial()) {
    on<LoadTaskReport>(_onLoadTaskReport);
    on<RefreshTaskReport>(_onRefreshTaskReport);
  }

  Future<void> _onLoadTaskReport(
    LoadTaskReport event,
    Emitter<TaskReportState> emit,
  ) async {
    emit(TaskReportLoading());

    try {
      final result = await _getTaskReportUseCase(event.eventId);
      result.fold(
        (failure) => emit(TaskReportError(message: failure.toString())),
        (report) => emit(TaskReportLoaded(report: report)),
      );
    } catch (e) {
      emit(TaskReportError(message: e.toString()));
    }
  }

  Future<void> _onRefreshTaskReport(
    RefreshTaskReport event,
    Emitter<TaskReportState> emit,
  ) async {
    // Mantém o estado atual durante o refresh se já tem dados
    final currentState = state;
    if (currentState is! TaskReportLoaded) {
      emit(TaskReportLoading());
    }

    try {
      final result = await _getTaskReportUseCase(event.eventId);
      result.fold(
        (failure) {
          // Se já tinha dados carregados, volta ao estado anterior em caso de erro
          if (currentState is TaskReportLoaded) {
            emit(currentState);
          } else {
            emit(TaskReportError(message: failure.toString()));
          }
        },
        (report) => emit(TaskReportLoaded(report: report)),
      );
    } catch (e) {
      // Se já tinha dados carregados, volta ao estado anterior em caso de erro
      if (currentState is TaskReportLoaded) {
        emit(currentState);
      } else {
        emit(TaskReportError(message: e.toString()));
      }
    }
  }
}
