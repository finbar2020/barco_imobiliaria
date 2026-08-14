import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import '../../../domain/use_cases/get_schedule_events_use_case.dart';
import '../../../domain/use_cases/reset_schedule_event_use_case.dart';
import '../../../domain/entity/schedule_event_task_entity.dart';
import '../../../domain/entity/schedule_events_detail_response_entity.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../home/widgets/task_card/task_card_enum.dart';
import '../../home/widgets/task_summary/task_summary_model.dart';
import 'schedule_events_event.dart';
import 'schedule_events_state.dart';

/// BLoC para gerenciar os eventos/tarefas agendados usando a nova API schedule-events
class ScheduleEventsBloc
    extends Bloc<ScheduleEventsEvent, ScheduleEventsState> {
  final GetScheduleEventsUseCase getScheduleEventsUseCase;
  final ResetScheduleEventUseCase resetScheduleEventUseCase;

  // Cache para evitar recarregamentos desnecessários
  String? _cachedDateKey;
  List<ScheduleEventTaskEntity>? _cachedEvents;
  List<ScheduleEventObligationEntity>? _cachedObligations;

  ScheduleEventsBloc({
    required this.getScheduleEventsUseCase,
    required this.resetScheduleEventUseCase,
  }) : super(ScheduleEventsInitialState()) {
    on<LoadScheduleEventsEvent>(_onLoadScheduleEvents);
    on<RefreshScheduleEventsEvent>(_onRefreshScheduleEvents);
    on<ResetScheduleEventEvent>(_onResetScheduleEvent);
    on<ClearScheduleEventsCacheEvent>(_onClearCache);
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

  Future<void> _onLoadScheduleEvents(
    LoadScheduleEventsEvent event,
    Emitter<ScheduleEventsState> emit,
  ) async {
    await _loadEvents(event, emit, useCache: true);
  }

  Future<void> _onRefreshScheduleEvents(
    RefreshScheduleEventsEvent event,
    Emitter<ScheduleEventsState> emit,
  ) async {
    await _loadEvents(
      LoadScheduleEventsEvent(
        selectedDate: event.selectedDate,
        userToken: event.userToken,
        sessionId: event.sessionId,
        appliedFilters: event.appliedFilters,
      ),
      emit,
      useCache: false,
    );
  }

  Future<void> _onResetScheduleEvent(
    ResetScheduleEventEvent event,
    Emitter<ScheduleEventsState> emit,
  ) async {
    emit(ResetScheduleEventLoadingState());

    try {
      final result = await resetScheduleEventUseCase(event.scheduleEventId);

      result.fold(
        (failure) {
          emit(ResetScheduleEventErrorState(
            message: _getErrorMessage(failure),
          ));
        },
        (resetResult) {
          emit(ResetScheduleEventSuccessState(resetResult: resetResult));
          // Limpar cache para forçar reload na próxima consulta
          _cachedDateKey = null;
          _cachedEvents = null;
          _cachedObligations = null;
        },
      );
    } catch (error) {
      emit(ResetScheduleEventErrorState(
        message: 'Erro inesperado ao resetar schedule event: $error',
      ));
    }
  }

  Future<void> _onClearCache(
    ClearScheduleEventsCacheEvent event,
    Emitter<ScheduleEventsState> emit,
  ) async {
    _cachedDateKey = null;
    _cachedEvents = null;
    _cachedObligations = null;
  }

  Future<void> _loadEvents(
    LoadScheduleEventsEvent event,
    Emitter<ScheduleEventsState> emit, {
    required bool useCache,
  }) async {
    final dateKey = DateFormat('dd/MM/yyyy').format(event.selectedDate);

    // Verificar cache se solicitado
    if (useCache && _cachedDateKey == dateKey && _cachedEvents != null) {
      emit(ScheduleEventsLoadedState(
        events: _cachedEvents!,
        obligations: _cachedObligations ?? const [],
        selectedDate: event.selectedDate,
      ));
      return;
    }

    emit(ScheduleEventsLoadingState());

    try {
      final filterParams = _convertFiltersToParams(event.appliedFilters);
      final params = GetScheduleEventsParams(
        date: event.selectedDate,
        typeTask: filterParams['typeTask'],
        status: filterParams['status'],
        assetIds: filterParams['assetIds'],
        localIds: filterParams['localIds'],
        responsibleIds: filterParams['responsibleIds'],
        pageName: event.pageName ?? "CALENDAR",
      );

      final result = await getScheduleEventsUseCase.call(params);

      result.fold(
        (failure) {
          emit(ScheduleEventsErrorState(
            message: 'Erro ao carregar events: ${_getErrorMessage(failure)}',
          ));
        },
        (response) async {
          var obligations = response.data.obligations;
          final currentPageName = (event.pageName ?? 'CALENDAR').toUpperCase();

          if (obligations.isEmpty && currentPageName != 'CALENDAR') {
            obligations = await _loadCalendarObligationsFallback(
              event: event,
              filterParams: filterParams,
            );
          }

          final hasTasks = response.data.taskSummaryDay.isNotEmpty;

          final tasks = hasTasks
              ? response.data.taskSummaryDay.first.taskFormulary
                  .map((formulary) {
                  final finalTimeStart = formulary.timeStart.isNotEmpty
                      ? formulary.timeStart
                      : _extractTimeFromDateTime(formulary.dtStart);
                  final finalTimeDescription =
                      formulary.timeDescription.isNotEmpty
                          ? formulary.timeDescription
                          : (formulary.allDay ? 'Dia Inteiro' : finalTimeStart);

                  return ScheduleEventTaskEntity(
                    idSchedule: formulary.idSchedule,
                    idScheduleEvent: formulary.idScheduleEvent,
                    typeTask: formulary.typeTask,
                    name: formulary.name,
                    fullDescription: formulary.description,
                    responsibleUserable: '',
                    procedureGroupId: '',
                    responsibleId: '',
                    timeStart: finalTimeStart,
                    timeDescription: finalTimeDescription,
                    dtStart: _formatDateIso(formulary.dtStart),
                    dtStartFormatted: _formatDateBr(formulary.dtStart),
                    status: formulary.status,
                    rrule: formulary.rrule.isEmpty ? null : formulary.rrule,
                    rruleDescription: null,
                    allDay: formulary.allDay,
                  );
                }).toList()
              : <ScheduleEventTaskEntity>[];

          if (tasks.isEmpty && obligations.isEmpty) {
            emit(ScheduleEventsEmptyState(selectedDate: event.selectedDate));
          } else {
            // Atualizar cache
            _cachedDateKey = dateKey;
            _cachedEvents = tasks;
            _cachedObligations = obligations;

            emit(ScheduleEventsLoadedState(
              events: tasks,
              obligations: obligations,
              taskSummary: null,
              selectedDate: event.selectedDate,
            ));
          }
        },
      );
    } catch (e) {
      emit(ScheduleEventsErrorState(
        message: 'Erro inesperado: ${e.toString()}',
      ));
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }

  Future<List<ScheduleEventObligationEntity>> _loadCalendarObligationsFallback({
    required LoadScheduleEventsEvent event,
    required Map<String, List<String>?> filterParams,
  }) async {
    try {
      final fallbackParams = GetScheduleEventsParams(
        date: event.selectedDate,
        typeTask: filterParams['typeTask'],
        status: filterParams['status'],
        assetIds: filterParams['assetIds'],
        localIds: filterParams['localIds'],
        responsibleIds: filterParams['responsibleIds'],
        pageName: 'CALENDAR',
      );

      final fallbackResult =
          await getScheduleEventsUseCase.call(fallbackParams);

      return fallbackResult.fold(
        (_) => <ScheduleEventObligationEntity>[],
        (calendarResponse) => calendarResponse.data.obligations,
      );
    } catch (_) {
      return <ScheduleEventObligationEntity>[];
    }
  }

  String _extractTimeFromDateTime(String isoDateTime) {
    try {
      final dateTime = DateTime.parse(isoDateTime);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00';
    }
  }

  String _formatDateIso(String isoDateTime) {
    try {
      final dateTime = DateTime.parse(isoDateTime);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  String _formatDateBr(String isoDateTime) {
    try {
      final dateTime = DateTime.parse(isoDateTime);
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (e) {
      return '';
    }
  }

  @override
  Future<void> close() {
    _cachedDateKey = null;
    _cachedEvents = null;
    _cachedObligations = null;
    return super.close();
  }
}
