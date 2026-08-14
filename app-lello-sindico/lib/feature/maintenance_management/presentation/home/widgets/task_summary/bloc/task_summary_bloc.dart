import 'package:essentials/essentials.dart';
import '../../../../../domain/use_cases/get_task_summary_use_case.dart';
import '../../../../../domain/entity/efficiency_entity.dart';
import 'task_summary_event.dart';
import 'task_summary_state.dart';

class TaskSummaryBloc extends Bloc<TaskSummaryEvent, TaskSummaryState> {
  final GetTaskSummaryUseCase getTaskSummaryUseCase;
  
  // Cache para evitar recarregamentos desnecessários
  String? _cachedWeekKey;
  TaskSummaryEntity? _cachedTaskSummary;

  TaskSummaryBloc({
    required this.getTaskSummaryUseCase,
  }) : super(TaskSummaryInitialState()) {
    on<LoadTaskSummaryEvent>(_onLoadTaskSummary);
    on<ClearTaskSummaryCacheEvent>(_onClearCache);
  }

  Future<void> _onLoadTaskSummary(
    LoadTaskSummaryEvent event,
    Emitter<TaskSummaryState> emit,
  ) async {
    // Gera uma chave única para a semana baseada nas datas de início e fim
    final weekKey = '${event.dtStart}_${event.untilDate}';
    
    // Verifica se já temos dados em cache para esta semana
    if (_cachedWeekKey == weekKey && _cachedTaskSummary != null) {
      // Retorna dados do cache sem fazer nova requisição
      emit(TaskSummaryLoadedState(taskSummary: _cachedTaskSummary!));
      return;
    }

    emit(TaskSummaryLoadingState());

    final request = GetTaskSummaryRequest(
      dtStart: event.dtStart,
      untilDate: event.untilDate,
    );

    final result = await getTaskSummaryUseCase.call(request);

    result.fold(
      (failure) {
        emit(TaskSummaryErrorState(
          message: 'Erro ao carregar resumo das tarefas: ${failure.toString()}',
        ));
      },
      (taskSummary) {
        // Armazena no cache
        _cachedWeekKey = weekKey;
        _cachedTaskSummary = taskSummary;
        
        emit(TaskSummaryLoadedState(taskSummary: taskSummary));
      },
    );
  }
  
  Future<void> _onClearCache(
    ClearTaskSummaryCacheEvent event,
    Emitter<TaskSummaryState> emit,
  ) async {
    clearCache();
    // Emite estado inicial para forçar reload no widget
    emit(TaskSummaryInitialState());
  }

  /// Limpa o cache quando necessário (ex: ao fazer refresh manual)
  void clearCache() {
    _cachedWeekKey = null;
    _cachedTaskSummary = null;
  }
}
