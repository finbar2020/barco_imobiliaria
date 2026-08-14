import 'package:essentials/essentials.dart';
import '../../../domain/use_cases/get_calendar_days_use_case.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../home/widgets/task_card/task_card_enum.dart';
import '../../home/widgets/task_summary/task_summary_model.dart';
import 'calendar_indicators_event.dart';
import 'calendar_indicators_state.dart';

class CalendarIndicatorsBloc
    extends Bloc<CalendarIndicatorsEvent, CalendarIndicatorsState> {
  final GetCalendarDaysUseCase getCalendarDaysUseCase;

  // Cache para evitar recarregamentos desnecessários
  String? _cachedMonthYearKey;
  CalendarIndicatorsLoadedState? _cachedState;

  CalendarIndicatorsBloc({
    required this.getCalendarDaysUseCase,
  }) : super(CalendarIndicatorsInitialState()) {
    on<LoadCalendarIndicatorsEvent>(_onLoadCalendarIndicators);
    on<RefreshCalendarIndicatorsEvent>(_onRefreshCalendarIndicators);
    on<ClearCalendarIndicatorsCacheEvent>(_onClearCache);
  }

  Map<String, List<String>?> _convertFiltersToParams(
      FilterOptionsEntity? filters) {
    if (filters == null) {
      return {
        'typeTask': null,
        'status': null,
        'assetIds': null,
        'localIds': null,
        'responsibleIds': null,
      };
    }

    return {
      'typeTask':
          filters.taskType.map((type) => _getTaskTypeString(type)).toList(),
      'status': filters.taskStatus
          .map((status) => _getTaskStatusString(status))
          .toList(),
      'assetIds': filters.assets.map((asset) => asset.id).toList(),
      'localIds': filters.locals.map((local) => local.id).toList(),
      'responsibleIds':
          filters.responsibles.map((responsible) => responsible.id).toList(),
    };
  }

  String _getTaskTypeString(TaskType type) {
    switch (type) {
      case TaskType.routine:
        return 'ROTINA';
      case TaskType.serviceOrder:
        return 'ORDEM_SERVICO';
    }
  }

  String _getTaskStatusString(TaskStatusType status) {
    switch (status) {
      case TaskStatusType.pending:
        return 'NOT_STARTED';
      case TaskStatusType.inProgress:
        return 'DRAFT';
      case TaskStatusType.completed:
        return 'DONE';
    }
  }

  Future<void> _onLoadCalendarIndicators(
    LoadCalendarIndicatorsEvent event,
    Emitter<CalendarIndicatorsState> emit,
  ) async {
    await _loadIndicators(event, emit, useCache: true);
  }

  Future<void> _onRefreshCalendarIndicators(
    RefreshCalendarIndicatorsEvent event,
    Emitter<CalendarIndicatorsState> emit,
  ) async {
    await _loadIndicators(
      LoadCalendarIndicatorsEvent(
        month: event.month,
        year: event.year,
        appliedFilters: event.appliedFilters,
      ),
      emit,
      useCache: false,
    );
  }

  Future<void> _onClearCache(
    ClearCalendarIndicatorsCacheEvent event,
    Emitter<CalendarIndicatorsState> emit,
  ) async {
    _cachedMonthYearKey = null;
    _cachedState = null;
  }

  Future<void> _loadIndicators(
    LoadCalendarIndicatorsEvent event,
    Emitter<CalendarIndicatorsState> emit, {
    required bool useCache,
  }) async {
    try {
      final monthYearKey = '${event.month}-${event.year}';

      // Verifica se pode usar cache
      if (useCache &&
          _cachedMonthYearKey == monthYearKey &&
          _cachedState != null) {
        emit(_cachedState!);
        return;
      }

      emit(CalendarIndicatorsLoadingState());

      final filterParams = _convertFiltersToParams(event.appliedFilters);

      final params = GetCalendarDaysParams(
        month: event.month,
        year: event.year,
        typeTask: filterParams['typeTask'],
        status: filterParams['status'],
        assetIds: filterParams['assetIds'],
        localIds: filterParams['localIds'],
        responsibleIds: filterParams['responsibleIds'],
      );

      final result = await getCalendarDaysUseCase.call(params);

      result.fold(
        (failure) {
          final errorMessage = _getErrorMessage(failure);
          emit(CalendarIndicatorsErrorState(
            message: errorMessage,
            month: event.month,
            year: event.year,
          ));
        },
        (calendarData) {
          if (calendarData.days.isEmpty) {
            emit(CalendarIndicatorsEmptyState(
              month: event.month,
              year: event.year,
            ));
            // Limpa cache quando vazio
            _cachedMonthYearKey = null;
            _cachedState = null;
          } else {
            final loadedState = CalendarIndicatorsLoadedState(
              calendarData: calendarData,
            );

            // Atualiza cache
            _cachedMonthYearKey = monthYearKey;
            _cachedState = loadedState;

            emit(loadedState);
          }
        },
      );
    } catch (e) {
      emit(CalendarIndicatorsErrorState(
        message: 'Erro inesperado: ${e.toString()}',
        month: event.month,
        year: event.year,
      ));
    }
  }

  String _getErrorMessage(Failure failure) {
    if (failure is UnknownFailure) {
      return 'Erro ao carregar indicadores do calendário: ${failure.error}';
    } else {
      return 'Erro ao carregar indicadores do calendário: ${failure.toString()}';
    }
  }

  bool hasTasksOnDay(int day) {
    final currentState = state;
    if (currentState is CalendarIndicatorsLoadedState) {
      return currentState.hasTasks(day);
    }
    return false;
  }

  int getTaskCountOnDay(int day) {
    final currentState = state;
    if (currentState is CalendarIndicatorsLoadedState) {
      return currentState.getTaskCount(day);
    }
    return 0;
  }
}
