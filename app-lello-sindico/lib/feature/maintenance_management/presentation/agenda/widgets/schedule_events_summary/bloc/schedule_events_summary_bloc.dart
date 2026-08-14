import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';
import '../../../../../domain/entity/efficiency_entity.dart';
import '../../../bloc/schedule_events_bloc.dart';
import '../../../bloc/schedule_events_state.dart';
import 'schedule_events_summary_event.dart';
import 'schedule_events_summary_state.dart';

class ScheduleEventsSummaryBloc
    extends Bloc<ScheduleEventsSummaryEvent, ScheduleEventsSummaryState> {
  final ScheduleEventsBloc scheduleEventsBloc;

  String? _cachedDateKey;
  TaskSummaryEntity? _cachedTaskSummary;

  ScheduleEventsSummaryBloc({
    required this.scheduleEventsBloc,
  }) : super(ScheduleEventsSummaryInitialState()) {
    on<LoadScheduleEventsSummaryEvent>(_onLoadScheduleEventsSummary);
    on<ClearScheduleEventsSummaryCacheEvent>(_onClearCache);
  }

  Future<void> _onLoadScheduleEventsSummary(
    LoadScheduleEventsSummaryEvent event,
    Emitter<ScheduleEventsSummaryState> emit,
  ) async {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final dateKey = dateFormat.format(event.selectedDate);
    if (_cachedDateKey == dateKey && _cachedTaskSummary != null) {
      emit(ScheduleEventsSummaryLoadedState(
        taskSummary: _cachedTaskSummary!,
        selectedDate: event.selectedDate,
      ));
      return;
    }

    emit(ScheduleEventsSummaryLoadingState());

    try {
      final currentState = scheduleEventsBloc.state;

      if (currentState is ScheduleEventsLoadedState &&
          _isSameDate(currentState.selectedDate, event.selectedDate)) {
        TaskSummaryEntity taskSummary;

        if (currentState.taskSummary != null) {
          taskSummary = currentState.taskSummary!;
        } else {
          final tasks = currentState.events;
          int done =
              tasks.where((task) => task.status.toUpperCase() == 'DONE').length;
          int notStarted = tasks
              .where((task) => task.status.toUpperCase() == 'NOT_STARTED')
              .length;
          int draft = tasks
              .where((task) => task.status.toUpperCase() == 'DRAFT')
              .length;

          taskSummary = TaskSummaryEntity(
            total: tasks.length,
            done: done,
            notStarted: notStarted,
            draft: draft,
            pending: 0,
          );
        }

        _cachedDateKey = dateKey;
        _cachedTaskSummary = taskSummary;

        emit(ScheduleEventsSummaryLoadedState(
          taskSummary: taskSummary,
          selectedDate: event.selectedDate,
        ));
        return;
      } else if (currentState is ScheduleEventsErrorState) {
        emit(ScheduleEventsSummaryErrorState(
          message:
              'Erro ao carregar resumo dos eventos: ${currentState.message}',
        ));
        return;
      } else if (currentState is ScheduleEventsEmptyState &&
          _isSameDate(currentState.selectedDate, event.selectedDate)) {
        final emptySummary = TaskSummaryEntity(
          total: 0,
          done: 0,
          notStarted: 0,
          draft: 0,
          pending: 0,
        );

        _cachedDateKey = dateKey;
        _cachedTaskSummary = emptySummary;

        emit(ScheduleEventsSummaryLoadedState(
          taskSummary: emptySummary,
          selectedDate: event.selectedDate,
        ));
        return;
      }

      final emptySummary = TaskSummaryEntity(
        total: 0,
        done: 0,
        notStarted: 0,
        draft: 0,
        pending: 0,
      );

      _cachedDateKey = dateKey;
      _cachedTaskSummary = emptySummary;

      emit(ScheduleEventsSummaryLoadedState(
        taskSummary: emptySummary,
        selectedDate: event.selectedDate,
      ));
    } catch (e) {
      emit(ScheduleEventsSummaryErrorState(
        message: 'Erro inesperado: ${e.toString()}',
      ));
    }
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _onClearCache(
    ClearScheduleEventsSummaryCacheEvent event,
    Emitter<ScheduleEventsSummaryState> emit,
  ) async {
    clearCache();
  }

  void clearCache() {
    _cachedDateKey = null;
    _cachedTaskSummary = null;
  }

  @override
  Future<void> close() {
    _cachedDateKey = null;
    _cachedTaskSummary = null;
    return super.close();
  }
}
