import 'package:essentials/essentials.dart';
import '../../../domain/entity/procedure_options_entity.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../../domain/entity/locals_lookup_entity.dart';
import '../../../domain/entity/assets_lookup_entity.dart';
import '../../../domain/entity/create_task_entity.dart';
import '../../../domain/use_cases/get_procedure_options_use_case.dart';
import '../../../domain/use_cases/get_maintenance_tasks_filter_options_use_case.dart';
import '../../../domain/use_cases/get_locals_lookup_use_case.dart';
import '../../../domain/use_cases/get_assets_lookup_use_case.dart';
import '../../../domain/use_cases/create_task_use_case.dart';
import '../../../domain/use_cases/create_task_from_schedule_use_case.dart';
import '../../../domain/entity/create_task_from_schedule_entity.dart';

// Events
abstract class CreateRoutineEvent {}

class LoadProcedureOptionsEvent extends CreateRoutineEvent {
  final String typeTask;

  LoadProcedureOptionsEvent(this.typeTask);
}

class SelectProcedureOptionEvent extends CreateRoutineEvent {
  final ProcedureOptionEntity selectedOption;

  SelectProcedureOptionEvent(this.selectedOption);
}

class ClearSelectionEvent extends CreateRoutineEvent {}

class ResetBlocEvent extends CreateRoutineEvent {}

class LoadFilterOptionsEvent extends CreateRoutineEvent {}

class LoadLocalsLookupEvent extends CreateRoutineEvent {
  final String procedureIds;

  LoadLocalsLookupEvent(this.procedureIds);
}

class LoadAssetsLookupEvent extends CreateRoutineEvent {
  final String procedureIds;

  LoadAssetsLookupEvent(this.procedureIds);
}

class CreateTaskEvent extends CreateRoutineEvent {
  final CreateTaskRequestEntity request;

  CreateTaskEvent(this.request);
}

class CreateTaskFromScheduleEvent extends CreateRoutineEvent {
  final String scheduleId;
  final String scheduleEventId;

  CreateTaskFromScheduleEvent({
    required this.scheduleId,
    required this.scheduleEventId,
  });
}

// States
abstract class CreateRoutineState {}

class CreateRoutineInitialState extends CreateRoutineState {}

class CreateRoutineLoadingState extends CreateRoutineState {}

class CreateRoutineLoadedState extends CreateRoutineState {
  final ProcedureOptionsEntity procedureOptions;
  final ProcedureOptionEntity? selectedOption;
  final FilterOptionsEntity? filterOptions;
  final LocalsLookupEntity? localsLookup;
  final AssetsLookupEntity? assetsLookup;

  CreateRoutineLoadedState({
    required this.procedureOptions,
    this.selectedOption,
    this.filterOptions,
    this.localsLookup,
    this.assetsLookup,
  });

  // Uso de parâmetros opcionais para controlar explicitamente quais valores devem ser substituídos
  CreateRoutineLoadedState copyWith({
    ProcedureOptionsEntity? procedureOptions,
    Object? selectedOption = const Object(),
    Object? filterOptions = const Object(),
    Object? localsLookup = const Object(),
    Object? assetsLookup = const Object(),
  }) {
    return CreateRoutineLoadedState(
      procedureOptions: procedureOptions ?? this.procedureOptions,
      selectedOption: selectedOption != const Object()
          ? selectedOption as ProcedureOptionEntity?
          : this.selectedOption,
      filterOptions: filterOptions != const Object()
          ? filterOptions as FilterOptionsEntity?
          : this.filterOptions,
      localsLookup: localsLookup != const Object()
          ? localsLookup as LocalsLookupEntity?
          : this.localsLookup,
      assetsLookup: assetsLookup != const Object()
          ? assetsLookup as AssetsLookupEntity?
          : this.assetsLookup,
    );
  }
}

class CreateRoutineErrorState extends CreateRoutineState {
  final String message;

  CreateRoutineErrorState(this.message);
}

class CreateRoutineCreatingTaskState extends CreateRoutineState {}

class CreateRoutineTaskCreatedState extends CreateRoutineState {
  final CreateTaskResponseEntity response;

  CreateRoutineTaskCreatedState(this.response);
}

class CreateRoutineTaskCreationErrorState extends CreateRoutineState {
  final String message;

  CreateRoutineTaskCreationErrorState(this.message);
}

class CreateRoutineCreatingTaskFromScheduleState extends CreateRoutineState {}

class CreateRoutineTaskFromScheduleCreatedState extends CreateRoutineState {
  final String taskId;
  final String eventId;
  final String taskName;
  final String? currentResponsibleName;

  CreateRoutineTaskFromScheduleCreatedState({
    required this.taskId,
    required this.eventId,
    required this.taskName,
    this.currentResponsibleName,
  });
}

class CreateRoutineTaskFromScheduleErrorState extends CreateRoutineState {
  final String message;

  CreateRoutineTaskFromScheduleErrorState(this.message);
}

// BLoC
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
  }) : super(CreateRoutineInitialState()) {
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
    emit(CreateRoutineLoadingState());

    final result = await getProcedureOptionsUseCase(event.typeTask);

    result.fold(
      (failure) => emit(CreateRoutineErrorState(failure is KnownFailure
          ? failure.message ?? "Erro desconhecido"
          : "Erro desconhecido")),
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
      // Limpar a seleção e os locais carregados para evitar problemas ao voltar
      // Usando o novo padrão de copyWith que suporta valores null explícitos
      _emitLoadedState(
        currentState.copyWith(
          selectedOption: null,
          localsLookup: null,
          assetsLookup: null,
        ),
        emit,
      );

      // Estado limpo: selectedOption e localsLookup definidos como null
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
            ? failure.message ?? "Erro ao carregar filtros"
            : "Erro ao carregar filtros")),
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
            ? failure.message ?? "Erro ao carregar locais"
            : "Erro ao carregar locais"));
      },
      (localsLookup) {
        if (currentState is CreateRoutineLoadedState) {
          _emitLoadedState(
            currentState.copyWith(localsLookup: localsLookup),
            emit,
          );
        } else {
          // Se ainda não temos um estado loaded, criar um novo com os locais
          _emitLoadedState(
            CreateRoutineLoadedState(
              procedureOptions: ProcedureOptionsEntity(procedureOptions: []),
              localsLookup: localsLookup,
              assetsLookup: null,
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
            ? failure.message ?? "Erro ao carregar ativos"
            : "Erro ao carregar ativos"));
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
              procedureOptions: ProcedureOptionsEntity(procedureOptions: []),
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
    emit(CreateRoutineInitialState());
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    emit(CreateRoutineCreatingTaskState());

    final result = await createTaskUseCase(event.request);
    result.fold(
      (failure) {
        emit(CreateRoutineTaskCreationErrorState(failure is KnownFailure
            ? failure.message ?? "Erro ao criar tarefa"
            : "Erro ao criar tarefa"));
        if (_lastLoadedState != null) {
          _emitLoadedState(_lastLoadedState!, emit);
        }
      },
      (response) {
        // Response agora sempre retorna idSchedule e idScheduleEvents
        // Se tiver dados, considera sucesso
        emit(CreateRoutineTaskCreatedState(response));
      },
    );
  }

  Future<void> _onCreateTaskFromSchedule(
    CreateTaskFromScheduleEvent event,
    Emitter<CreateRoutineState> emit,
  ) async {
    emit(CreateRoutineCreatingTaskFromScheduleState());

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
