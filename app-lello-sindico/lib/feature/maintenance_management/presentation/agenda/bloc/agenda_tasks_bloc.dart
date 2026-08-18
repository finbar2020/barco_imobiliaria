import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import '../../../domain/use_cases/get_maintenance_task_events_use_case.dart';
import '../../../domain/entity/maintenance_task_event_entity.dart';
import 'agenda_tasks_event.dart';
import 'agenda_tasks_state.dart';

class AgendaTasksBloc extends Bloc<AgendaTasksEvent, AgendaTasksState> {
  final GetMaintenanceTaskEventsUseCase getMaintenanceTaskEventsUseCase;

  String? _cachedDateKey;
  List<MaintenanceTaskEventEntity>? _cachedTasks;

  AgendaTasksBloc({
    required this.getMaintenanceTaskEventsUseCase,
  }) : super(AgendaTasksInitialState()) {
    on<LoadAgendaTasksEvent>(_onLoadAgendaTasks);
    on<RefreshAgendaTasksEvent>(_onRefreshAgendaTasks);
    on<ClearAgendaTasksCacheEvent>(_onClearCache);
  }

  Future<void> _onLoadAgendaTasks(
    LoadAgendaTasksEvent event,
    Emitter<AgendaTasksState> emit,
  ) async {
    await _loadTasks(event, emit, useCache: true);
  }

  Future<void> _onRefreshAgendaTasks(
    RefreshAgendaTasksEvent event,
    Emitter<AgendaTasksState> emit,
  ) async {
    await _loadTasks(
      LoadAgendaTasksEvent(
        selectedDate: event.selectedDate,
        orderBy: event.orderBy,
        taskTypes: event.taskTypes,
        taskStatus: event.taskStatus,
        locals: event.locals,
        assets: event.assets,
        responsibles: event.responsibles,
        employeeGroups: event.employeeGroups,
      ),
      emit,
      useCache: false,
    );
  }

  Future<void> _onClearCache(
    ClearAgendaTasksCacheEvent event,
    Emitter<AgendaTasksState> emit,
  ) async {
    clearCache();
  }

  Future<void> _loadTasks(
    LoadAgendaTasksEvent event,
    Emitter<AgendaTasksState> emit, {
    required bool useCache,
  }) async {
    // Gera uma chave única para o cache baseada na data
    final dateKey = DateFormat('yyyy-MM-dd').format(event.selectedDate);

    // Verifica se já temos dados em cache para esta data
    if (useCache && _cachedDateKey == dateKey && _cachedTasks != null) {
      final filteredAndSortedTasks = _filterAndSortTasks(_cachedTasks!, event);
      emit(AgendaTasksLoadedState(
        tasks: filteredAndSortedTasks,
        selectedDate: event.selectedDate,
        orderBy: event.orderBy,
        totalTasks: filteredAndSortedTasks.length,
      ));
      return;
    }

    emit(AgendaTasksLoadingState());

    try {
      final startOfDay = DateTime(
        event.selectedDate.year,
        event.selectedDate.month,
        event.selectedDate.day,
      );
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));

      final params = GetMaintenanceTaskEventsParams(
        dtStart: startOfDay,
        untilDate: endOfDay,
        typeTask: event.taskTypes ?? [],
        status: event.taskStatus ?? [],
        dayCurrent: event.selectedDate,
        procedureGroupLabels: event.employeeGroups,
        assetIds: event.assets,
        localIds: event.locals,
        responsibleIds: event.responsibles,
      );

      // Chama a API
      final result = await getMaintenanceTaskEventsUseCase.call(params);

      result.fold(
        (failure) {
          emit(AgendaTasksErrorState(
            message: 'Erro ao carregar tarefas: ${failure.toString()}',
            selectedDate: event.selectedDate,
          ));
        },
        (response) {
          // Armazena no cache
          _cachedDateKey = dateKey;
          _cachedTasks = response.taskFormulary;

          // Filtra tarefas da data específica (garantia extra)
          final tasksForDate = response.taskFormulary.where((task) {
            final taskDate = DateTime.parse(task.dtstart);
            final taskDay =
                DateTime(taskDate.year, taskDate.month, taskDate.day);
            final selectedDay = DateTime(
              event.selectedDate.year,
              event.selectedDate.month,
              event.selectedDate.day,
            );
            return taskDay == selectedDay;
          }).toList();

          final filteredAndSortedTasks =
              _filterAndSortTasks(tasksForDate, event);

          if (filteredAndSortedTasks.isEmpty) {
            emit(AgendaTasksEmptyState(
              selectedDate: event.selectedDate,
              message: 'Nenhuma tarefa encontrada para esta data',
            ));
          } else {
            emit(AgendaTasksLoadedState(
              tasks: filteredAndSortedTasks,
              selectedDate: event.selectedDate,
              orderBy: event.orderBy,
              totalTasks: filteredAndSortedTasks.length,
            ));
          }
        },
      );
    } catch (error) {
      emit(AgendaTasksErrorState(
        message: 'Erro inesperado ao carregar tarefas: $error',
        selectedDate: event.selectedDate,
      ));
    }
  }

  List<MaintenanceTaskEventEntity> _filterAndSortTasks(
    List<MaintenanceTaskEventEntity> tasks,
    LoadAgendaTasksEvent event,
  ) {
    List<MaintenanceTaskEventEntity> filteredTasks = List.from(tasks);

    if (event.orderBy == 'data') {
      filteredTasks.sort((a, b) {
        final dateA = DateTime.parse(a.dtstart);
        final dateB = DateTime.parse(b.dtstart);
        return dateA.compareTo(dateB);
      });
    } else if (event.orderBy == 'tipo') {
      filteredTasks.sort((a, b) {
        // Primeiro ordena por tipo, depois por data
        final typeComparison = a.typeTask.compareTo(b.typeTask);
        if (typeComparison != 0) return typeComparison;

        final dateA = DateTime.parse(a.dtstart);
        final dateB = DateTime.parse(b.dtstart);
        return dateA.compareTo(dateB);
      });
    }

    return filteredTasks;
  }

  void clearCache() {
    _cachedDateKey = null;
    _cachedTasks = null;
  }
}
