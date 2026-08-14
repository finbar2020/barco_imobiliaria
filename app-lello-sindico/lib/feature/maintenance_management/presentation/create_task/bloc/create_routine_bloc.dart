import 'package:essentials/essentials.dart';

import '../../../domain/entity/assets_lookup_entity.dart';
import '../../../domain/entity/create_task_from_schedule_entity.dart';
import '../../../domain/entity/locals_lookup_entity.dart';
import '../../../domain/entity/procedure_options_entity.dart';
import '../../../domain/use_cases/create_task_from_schedule_use_case.dart';
import '../../../domain/use_cases/create_task_use_case.dart';
import '../../../domain/use_cases/get_assets_lookup_use_case.dart';
import '../../../domain/use_cases/get_locals_lookup_use_case.dart';
import '../../../domain/use_cases/get_maintenance_tasks_filter_options_use_case.dart';
import '../../../domain/use_cases/get_procedure_options_use_case.dart';
import 'create_routine_event.dart';
import 'create_routine_state.dart';

// Re-exportar para manter compatibilidade com quem importa apenas o bloc
export 'create_routine_event.dart';
export 'create_routine_state.dart';

class CreateRoutineBloc extends Bloc<CreateRoutineEvent, CreateRoutineState> {
  final GetProcedureOptionsUseCase getProcedureOptionsUseCase;
  final GetMaintenanceTasksFilterOptionsUseCase getFilterOptionsUseCase;
  final GetLocalsLookupUseCase getLocalsLookupUseCase;
  final GetAssetsLookupUseCase getAssetsLookupUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final CreateTaskFromScheduleUseCase createTaskFromScheduleUseCase;

  CreateRoutineLoadedState? _lastLoadedState;

  CreateRoutineBloc({
    required this.getProcedureOptionsUseCase,
    required this.getFilterOptionsUseCase,
    required this.getLocalsLookupUseCase,
    required this.getAssetsLookupUseCase,
    required this.createTaskUseCase,
    required this.createTaskFromScheduleUseCase,
  }) : super(const CreateRoutineInitialState()) {
    on<LoadProcedureOptionsEvent>(_onLoadProcedureOptions);
    on<SelectProcedureOptionEvent>(_onSelectProcedureOption);
    on<ClearSelectionEvent>(_onClearSelection);
    on<LoadFilterOptionsEvent>(_onLoadFilterOptions);
    on<LoadLocalsLookupEvent>(_onLoadLocalsLookup);
    on<LoadAssetsLookupEvent>(_onLoadAssetsLookup);
    on<ResetBlocEvent>(_onResetBloc);
    on<CreateTaskEvent>(_onCreateTask);
    on<CreateTaskFromScheduleEvent>(_onCreateTaskFromSchedule);
  }

  void _emitLoadedState(
    CreateRoutineLoadedState state,
    Emitter<CreateRoutineState> emit,
  ) {
    _lastLoadedState = state;
    emit(state);
  }

  Future<void> _onLoadProcedureOptions(
    LoadProcedureOptionsEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    emit(const CreateRoutineLoadingState());

    final result = await getProcedureOptionsUseCase(event.typeTask);

    result.fold(
      (failure) => emit(CreateRoutineErrorState(failure is KnownFailure
          ? failure.message ?? 'Erro desconhecido'
          : 'Erro desconhecido')),
      (procedureOptions) {
        _emitLoadedState(
          CreateRoutineLoadedState(procedureOptions: procedureOptions),
          emit,
        );
      },
    );
  }

  void _onSelectProcedureOption(
    SelectProcedureOptionEvent event,
    Emitter<CreateRoutineState> emit,
  ) {
    final currentState = state;
    if (currentState is CreateRoutineLoadedState) {
      _emitLoadedState(
        currentState.copyWith(selectedOption: event.selectedOption),
        emit,
      );
    }
  }

  void _onClearSelection(
    ClearSelectionEvent event,
    Emitter<CreateRoutineState> emit,
  ) {
    final currentState = state;
    if (currentState is CreateRoutineLoadedState) {
      // Limpa seleÃ§Ã£o, locais e ativos usando null explÃ­cito.
      _emitLoadedState(
        currentState.copyWith(
          selectedOption: null,
          localsLookup: null,
          assetsLookup: null,
        ),
        emit,
      );
    }
  }

  Future<void> _onLoadFilterOptions(
    LoadFilterOptionsEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    final currentState = state;
    if (currentState is CreateRoutineLoadedState) {
      final result = await getFilterOptionsUseCase();
      result.fold(
        (failure) => emit(CreateRoutineErrorState(failure is KnownFailure
            ? failure.message ?? 'Erro ao carregar filtros'
            : 'Erro ao carregar filtros')),
        (filterOptions) {
          _emitLoadedState(
            currentState.copyWith(filterOptions: filterOptions),
            emit,
          );
        },
      );
    }
  }

  Future<void> _onLoadLocalsLookup(
    LoadLocalsLookupEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    final currentState = state;

    final result = await getLocalsLookupUseCase(event.procedureIds);
    result.fold(
      (failure) {
        final fallbackState = currentState is CreateRoutineLoadedState
            ? currentState
            : _lastLoadedState;

        if (fallbackState != null) {
          _emitLoadedState(
            fallbackState.copyWith(
              localsLookup: LocalsLookupEntity(locals: const []),
            ),
            emit,
          );
          return;
        }

        emit(CreateRoutineErrorState(failure is KnownFailure
            ? failure.message ?? 'Erro ao carregar locais'
            : 'Erro ao carregar locais'));
      },
      (localsLookup) {
        if (currentState is CreateRoutineLoadedState) {
          _emitLoadedState(
            currentState.copyWith(localsLookup: localsLookup),
            emit,
          );
        } else {
          // Se ainda nÃ£o temos um estado loaded, criar um novo com os locais
          _emitLoadedState(
            CreateRoutineLoadedState(
              procedureOptions:
                  ProcedureOptionsEntity(procedureOptions: []),
              localsLookup: localsLookup,
            ),
            emit,
          );
        }
      },
    );
  }

  Future<void> _onLoadAssetsLookup(
    LoadAssetsLookupEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    final currentState = state;

    final result = await getAssetsLookupUseCase(event.procedureIds);
    result.fold(
      (failure) {
        final fallbackState = currentState is CreateRoutineLoadedState
            ? currentState
            : _lastLoadedState;

        if (fallbackState != null) {
          _emitLoadedState(
            fallbackState.copyWith(
              assetsLookup: AssetsLookupEntity(assets: const []),
            ),
            emit,
          );
          return;
        }

        emit(CreateRoutineErrorState(failure is KnownFailure
            ? failure.message ?? 'Erro ao carregar ativos'
            : 'Erro ao carregar ativos'));
      },
      (assetsLookup) {
        if (currentState is CreateRoutineLoadedState) {
          _emitLoadedState(
            currentState.copyWith(assetsLookup: assetsLookup),
            emit,
          );
        } else {
          _emitLoadedState(
            CreateRoutineLoadedState(
              procedureOptions:
                  ProcedureOptionsEntity(procedureOptions: []),
              assetsLookup: assetsLookup,
            ),
            emit,
          );
        }
      },
    );
  }

  void _onResetBloc(
    ResetBlocEvent event,
    Emitter<CreateRoutineState> emit,
  ) {
    emit(const CreateRoutineInitialState());
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    emit(const CreateRoutineCreatingTaskState());

    final result = await createTaskUseCase(event.request);
    result.fold(
      (failure) {
        emit(CreateRoutineTaskCreationErrorState(failure is KnownFailure
            ? failure.message ?? 'Erro ao criar tarefa'
            : 'Erro ao criar tarefa'));
        if (_lastLoadedState != null) {
          _emitLoadedState(_lastLoadedState!, emit);
        }
      },
      (response) {
        emit(CreateRoutineTaskCreatedState(response));
      },
    );
  }

  Future<void> _onCreateTaskFromSchedule(
    CreateTaskFromScheduleEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    emit(const CreateRoutineCreatingTaskFromScheduleState());

    final request = CreateTaskFromScheduleRequestEntity(
      scheduleId: event.scheduleId,
      scheduleEventId: event.scheduleEventId,
    );

    final result = await createTaskFromScheduleUseCase(request);

    result.fold(
      (failure) {
        emit(CreateRoutineTaskFromScheduleErrorState(
            'Erro ao criar tarefa: ${failure.toString()}'));
      },
      (response) {
        emit(CreateRoutineTaskFromScheduleCreatedState(
          taskId: response.task.id,
          eventId: response.event.id,
          taskName: response.task.name,
          currentResponsibleName: response.task.currentResponsibleName,
        ));
      },
    );
  }
}

