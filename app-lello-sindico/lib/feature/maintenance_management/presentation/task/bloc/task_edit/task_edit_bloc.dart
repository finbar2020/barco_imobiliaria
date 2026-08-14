import 'package:essentials/essentials.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entity/task_details_entity.dart';
import '../../../../domain/entity/edit_schedule_event_entity.dart';
import '../../../../domain/use_cases/edit_schedule_event_use_case.dart';
import 'task_edit_event.dart';
import 'task_edit_state.dart';

class TaskEditBloc extends Bloc<TaskEditEvent, TaskEditState> {
  final EditScheduleEventUseCase _editScheduleEventUseCase;

  TaskEditBloc(this._editScheduleEventUseCase) : super(_initialState()) {
    on<TaskEditStartedEvent>(_onStarted);
    on<TaskEditToggleAllDayEvent>(_onToggleAllDay);
    on<TaskEditCheckInChangedEvent>(_onCheckInChanged);
    on<TaskEditModeChangedEvent>(_onModeChanged);
    on<TaskEditReminderChangedEvent>(_onReminderChanged);
    on<TaskEditWeekDayToggledEvent>(_onWeekDayToggled);
    on<TaskEditOrientationChangedEvent>(_onOrientationChanged);
    on<TaskEditDiscardPressedEvent>(_onDiscardPressed);
    on<TaskEditSavePressedEvent>(_onSavePressed);
    on<TaskEditDialogDismissedEvent>(_onDialogDismissed);
    on<TaskEditScopeSelectedEvent>(_onScopeSelected);
    on<TaskEditConfirmScopeEvent>(_onConfirmScope);
    on<TaskEditConfirmDiscardEvent>(_onConfirmDiscard);
    on<TaskEditStatusClearedEvent>(_onOutcomeCleared);
    on<TaskEditStartDateChangedEvent>(_onStartDateChanged);
    on<TaskEditEndDateChangedEvent>(_onEndDateChanged);
  }

  static TaskEditState _initialState() => TaskEditState(
        task: TaskDetailsEntity(
          id: '',
          scheduleId: null,
          taskId: null,
          name: '',
          status: '',
          typeTask: '',
          allDay: false,
        ),
        mode: TaskScheduleMode.daily,
        isAllDay: true,
        checkInTime: null,
        reminder: '1 dia antes',
        selectedWeekDays: {},
        orientation: '',
      );

  void initialize(TaskDetailsEntity task) {
    add(TaskEditStartedEvent(task));
  }

  void _onStarted(TaskEditStartedEvent event, Emitter<TaskEditState> emit) {
    final schedule = event.task.schedule;
    final rRule = event.task.rRule;
    final rruleString = schedule?.rrule ?? '';

    // Determina modo baseado na frequência do rRule
    final mode = _getModeFromTask(rRule, rruleString);

    emit(
      TaskEditState(
        task: event.task,
        mode: mode,
        isAllDay: schedule?.allDay ?? event.task.allDay,
        checkInTime: schedule?.timeStart ?? event.task.timeStart,
        reminder: '1 dia antes',
        selectedWeekDays: mode == TaskScheduleMode.weekly
            ? (rRule?.byDays != null
                ? _weekDaysFromByDays(rRule!.byDays!)
                : _weekDaysFromRrule(rruleString))
            : {},
        orientation: event.task.procedure?.description ?? '',
        startDate: event.task.dtStart,
        endDate: event.task.until,
      ),
    );
  }

  TaskScheduleMode _getModeFromTask(TaskDetailsRRuleEntity? rRule, String rruleString) {
    // Tenta obter da propriedade frequency do rRule
    final frequency = rRule?.frequency;
    if (frequency != null) {
      switch (frequency.toUpperCase()) {
        case 'DAILY':
          return TaskScheduleMode.daily;
        case 'WEEKLY':
          // Se tem 7 dias selecionados, é diária
          if (rRule?.byDays?.length == 7) {
            return TaskScheduleMode.daily;
          }
          return TaskScheduleMode.weekly;
        case 'MONTHLY':
          return TaskScheduleMode.monthly;
        case 'YEARLY':
          return TaskScheduleMode.yearly;
      }
    }

    // Fallback: tenta parsear da string rrule
    if (rruleString.contains('FREQ=YEARLY')) {
      return TaskScheduleMode.yearly;
    }
    if (rruleString.contains('FREQ=MONTHLY')) {
      return TaskScheduleMode.monthly;
    }
    if (rruleString.contains('FREQ=WEEKLY')) {
      // Se tem 7 dias, é diária
      if (_weekDaysFromRrule(rruleString).length == 7) {
        return TaskScheduleMode.daily;
      }
      return TaskScheduleMode.weekly;
    }
    if (rruleString.contains('FREQ=DAILY')) {
      return TaskScheduleMode.daily;
    }

    // Default
    return TaskScheduleMode.daily;
  }

  void _onToggleAllDay(
      TaskEditToggleAllDayEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(isAllDay: event.value));
  }

  void _onCheckInChanged(
      TaskEditCheckInChangedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(checkInTime: event.value));
  }

  void _onModeChanged(TaskEditModeChangedEvent event, Emitter<TaskEditState> emit) {
    final shouldClearWeekDays = event.mode == TaskScheduleMode.daily;
    emit(
      state.copyWith(
        mode: event.mode,
        selectedWeekDays:
            shouldClearWeekDays ? <TaskWeekDay>{} : state.selectedWeekDays,
      ),
    );
  }

  void _onReminderChanged(
      TaskEditReminderChangedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(reminder: event.value));
  }

  void _onWeekDayToggled(
      TaskEditWeekDayToggledEvent event, Emitter<TaskEditState> emit) {
    final updated = Set<TaskWeekDay>.from(state.selectedWeekDays);
    if (updated.contains(event.day)) {
      updated.remove(event.day);
    } else {
      updated.add(event.day);
    }
    emit(state.copyWith(selectedWeekDays: updated));
  }

  void _onOrientationChanged(
      TaskEditOrientationChangedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(orientation: event.value));
  }

  void _onDiscardPressed(
      TaskEditDiscardPressedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(dialog: TaskEditDialogType.discard));
  }

  void _onSavePressed(TaskEditSavePressedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(dialog: TaskEditDialogType.scope));
  }

  void _onDialogDismissed(
      TaskEditDialogDismissedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(dialog: TaskEditDialogType.none, pendingScope: null));
  }

  void _onScopeSelected(
      TaskEditScopeSelectedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(pendingScope: event.scope));
  }

  Future<void> _onConfirmScope(
      TaskEditConfirmScopeEvent event, Emitter<TaskEditState> emit) async {
    emit(
      state.copyWith(
        dialog: TaskEditDialogType.none,
        isSaving: true,
      ),
    );

    final selectedScope = state.pendingScope ?? TaskEditScope.current;

    // Mapear TaskEditScope para updateType da API
    final updateType = selectedScope == TaskEditScope.current
        ? 'THIS_SCHEDULE_EVENT'
        : 'NEXT_SCHEDULE_EVENTS';

    try {
      // Preparar os dados da request
      final task = state.task;
      final schedule = task.schedule;

      // Formatar dtStart
      String formattedDtStart;
      if (task.dtStart != null && task.dtStart!.isNotEmpty) {
        try {
          final dtStartDate = DateTime.parse(task.dtStart!);
          formattedDtStart = DateFormat('dd/MM/yyyy').format(dtStartDate);
        } catch (_) {
          formattedDtStart = task.dtStart!;
        }
      } else {
        formattedDtStart = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }

      // Formatar until se disponível
      String? formattedUntil;
      if (task.until != null && task.until!.isNotEmpty) {
        try {
          final untilDate = DateTime.parse(task.until!);
          formattedUntil = DateFormat('dd/MM/yyyy').format(untilDate);
        } catch (_) {
          formattedUntil = task.until;
        }
      }

      // Construir rrule baseado no modo selecionado
      EditScheduleEventRRuleEntity? rrule;
      if (state.mode == TaskScheduleMode.weekly &&
          state.selectedWeekDays.isNotEmpty) {
        final byDays = state.selectedWeekDays
            .map((day) => _weekDayToApiString(day))
            .toList();
        rrule = EditScheduleEventRRuleEntity(
          frequency: 'WEEKLY',
          byDays: byDays,
        );
      } else if (state.mode == TaskScheduleMode.daily) {
        rrule = EditScheduleEventRRuleEntity(
          frequency: 'DAILY',
          byDays: null,
        );
      } else if (state.mode == TaskScheduleMode.monthly) {
        rrule = EditScheduleEventRRuleEntity(
          frequency: 'MONTHLY',
          byDays: null,
        );
      } else if (state.mode == TaskScheduleMode.yearly) {
        rrule = EditScheduleEventRRuleEntity(
          frequency: 'YEARLY',
          byDays: null,
        );
      }

      // Verificar se é ordem de serviço ou rotina
      final isServiceOrder = task.typeTask == 'ORDEM_SERVICO';
      
      // Verificar se está editando apenas a tarefa atual
      final isEditingCurrentOnly = updateType == 'THIS_SCHEDULE_EVENT';

      // Para ROTINA: repeat = true se tiver modo (qualquer frequência)
      // Para ORDEM_SERVICO: repeat = false sempre
      final shouldRepeat = !isServiceOrder &&
          (state.mode == TaskScheduleMode.daily ||
              (state.mode == TaskScheduleMode.weekly &&
                  state.selectedWeekDays.isNotEmpty) ||
              state.mode == TaskScheduleMode.monthly ||
              state.mode == TaskScheduleMode.yearly);

      // dtStart:
      // - Para rotinas: sempre usa state.startDate (data selecionada) se disponível
      // - Para ordem de serviço: usa state.startDate se disponível
      final dtStartValue = state.startDate ?? formattedDtStart;

      // until:
      // - Para rotinas: sempre usa state.startDate (mesma data que dtStart)
      // - Para ordem de serviço: usa endDate
      final untilValue = isServiceOrder
          ? (state.endDate ?? formattedUntil)
          : (state.startDate ?? formattedDtStart);

      final request = EditScheduleEventRequestEntity(
        idSchedule: task.scheduleId ?? schedule?.scheduleId ?? '',
        idScheduleEvent: task.taskId ?? schedule?.id ?? '',
        dtStart: dtStartValue,
        timeStart: state.isAllDay ? null : state.checkInTime,
        timeEnd: '', // Sempre string vazia na edição (tanto Rotina quanto OS)
        allDay: state.isAllDay,
        repeat: shouldRepeat,
        until: untilValue,
        procedureGroupId: task.procedureGroup?.id ?? schedule?.procedureGroupId,
        procedureId: task.procedure?.id ?? schedule?.procedureId,
        localId: task.localId ?? schedule?.localId,
        assetId: task.assetId ?? schedule?.assetId,
        updateType: updateType,
        rrule: rrule,
      );

      final result = await _editScheduleEventUseCase(request);

      await result.fold(
        (failure) {
          emit(
            state.copyWith(
              isSaving: false,
              pendingScope: null,
              outcome: TaskEditStatus.error,
              errorMessage: 'Erro ao editar evento',
            ),
          );
        },
        (response) {
          // Verificar se o backend retornou success: false
          if (!response.success) {
            emit(
              state.copyWith(
                isSaving: false,
                pendingScope: null,
                outcome: TaskEditStatus.error,
                errorMessage: response.message ?? 'Erro ao editar evento',
              ),
            );
            return;
          }

          final outcome = selectedScope == TaskEditScope.fromThis
              ? TaskEditStatus.savedFuture
              : TaskEditStatus.savedSingle;

          emit(
            state.copyWith(
              isSaving: false,
              pendingScope: null,
              outcome: outcome,
              errorMessage: null,
              editedTaskId: response.data, // Armazena ID retornado pela API
            ),
          );
        },
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSaving: false,
          pendingScope: null,
          outcome: TaskEditStatus.error,
          errorMessage: 'Erro inesperado ao editar evento',
        ),
      );
    }
  }

  String _weekDayToApiString(TaskWeekDay day) {
    switch (day) {
      case TaskWeekDay.sunday:
        return 'SU';
      case TaskWeekDay.monday:
        return 'MO';
      case TaskWeekDay.tuesday:
        return 'TU';
      case TaskWeekDay.wednesday:
        return 'WE';
      case TaskWeekDay.thursday:
        return 'TH';
      case TaskWeekDay.friday:
        return 'FR';
      case TaskWeekDay.saturday:
        return 'SA';
    }
  }

  void _onConfirmDiscard(
      TaskEditConfirmDiscardEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(
      dialog: TaskEditDialogType.none,
      outcome: TaskEditStatus.discarded,
    ));
  }

  void _onOutcomeCleared(
      TaskEditStatusClearedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(outcome: null));
  }

  void _onStartDateChanged(
      TaskEditStartDateChangedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(startDate: event.date));
  }

  void _onEndDateChanged(
      TaskEditEndDateChangedEvent event, Emitter<TaskEditState> emit) {
    emit(state.copyWith(endDate: event.date));
  }

  Set<TaskWeekDay> _weekDaysFromRrule(String rrule) {
    final match = RegExp(r'BYDAY=([^;]+)').firstMatch(rrule);
    if (match == null) return {};
    final codes = match.group(1)!.split(',');
    return codes.map(_mapWeekDay).whereType<TaskWeekDay>().toSet();
  }

  Set<TaskWeekDay> _weekDaysFromByDays(List<String> byDays) {
    return byDays.map(_mapWeekDay).whereType<TaskWeekDay>().toSet();
  }

  TaskWeekDay? _mapWeekDay(String code) {
    switch (code.toUpperCase()) {
      case 'SU':
        return TaskWeekDay.sunday;
      case 'MO':
        return TaskWeekDay.monday;
      case 'TU':
        return TaskWeekDay.tuesday;
      case 'WE':
        return TaskWeekDay.wednesday;
      case 'TH':
        return TaskWeekDay.thursday;
      case 'FR':
        return TaskWeekDay.friday;
      case 'SA':
        return TaskWeekDay.saturday;
      default:
        return null;
    }
  }
}
