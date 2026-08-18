import 'package:essentials/essentials.dart';
import '../../../domain/use_cases/get_task_details_use_case.dart';
import '../../../domain/use_cases/get_task_formularies_use_case.dart';
import '../../../domain/use_cases/get_task_files_use_case.dart';
import '../../../domain/use_cases/create_task_from_schedule_use_case.dart';
import '../../../domain/entity/task_formularies_entity.dart';
import '../../../domain/entity/task_files_entity.dart';
import '../../../domain/entity/create_task_from_schedule_entity.dart';
import 'task_details_bloc.dart';
import 'task_details_event.dart';
import 'task_details_state.dart';

class TaskDetailsBlocImpl extends TaskDetailsBloc {
  final GetTaskDetailsUseCase _getTaskDetailsUseCase;
  final GetTaskFormulariesUseCase _getTaskFormulariesUseCase;
  final GetTaskFilesUseCase _getTaskFilesUseCase;
  final CreateTaskFromScheduleUseCase _createTaskFromScheduleUseCase;

  TaskDetailsBlocImpl(
    this._getTaskDetailsUseCase,
    this._getTaskFormulariesUseCase,
    this._getTaskFilesUseCase,
    this._createTaskFromScheduleUseCase,
  ) : super(TaskDetailsInitialState()) {
    on<LoadTaskDetailsEvent>(_onLoadTaskDetails);
    on<ChangeTabEvent>(_onChangeTab);
    on<CreateTaskFromScheduleEvent>(_onCreateTaskFromSchedule);
  }

  @override
  Future<void> loadTaskDetails(String taskId) async {
    add(LoadTaskDetailsEvent(taskId));
  }

  @override
  void changeTab(TaskDetailsTabType tabType) {
    add(ChangeTabEvent(tabType));
  }

  Future<void> _onLoadTaskDetails(
    LoadTaskDetailsEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    emit(TaskDetailsLoadingState());

    final result = await _getTaskDetailsUseCase(
      GetTaskDetailsRequest(taskId: event.taskId),
    );

    await result.fold(
      (failure) {
        emit(TaskDetailsErrorState(
            'Erro ao carregar detalhes da tarefa: ${failure.toString()}'));
      },
      (task) async {
        emit(TaskDetailsLoadedState(
          task: task,
          isLoadingFormularies: true,
          isLoadingFiles: true,
        ));

        // Usar o taskId correto (task.task.id) para carregar arquivos
        // e event.taskId (scheduleEventId) para carregar formulários
        final taskIdForFiles = task.task?.id ?? event.taskId;
        
        final futures = <Future<dynamic>>[
          _getTaskFormulariesUseCase(
            GetTaskFormulariesRequest(taskId: event.taskId),
          ),
          _getTaskFilesUseCase(
            GetTaskFilesRequest(taskId: taskIdForFiles),
          ),
        ];

        final results = await Future.wait(futures);

        final formulariesResult = results[0];
        final filesResult = results[1];

        final formularies = formulariesResult.fold(
          (failure) {
            print('🔴 DEBUG: Erro ao carregar formularies: $failure');
            return <TaskFormularyEntity>[];
          },
          (response) {
            final formulariesList =
                (response as TaskFormulariesResponseEntity).formularies;
            print('✅ DEBUG: Formularies carregados: ${formulariesList.length}');
            return formulariesList;
          },
        );

        final files = filesResult.fold(
          (failure) => <TaskFileEntity>[],
          (response) => (response as TaskFilesResponseEntity).files,
        );

        emit(TaskDetailsLoadedState(
          task: task,
          formularies: formularies,
          files: files,
          isLoadingFormularies: false,
          isLoadingFiles: false,
        ));
      },
    );
  }

  void _onChangeTab(
    ChangeTabEvent event,
    Emitter<TaskDetailsState> emit,
  ) {
    final currentState = state;
    if (currentState is TaskDetailsLoadedState) {
      emit(currentState.copyWith(selectedTab: event.tabType));
    }
  }

  Future<void> _onCreateTaskFromSchedule(
    CreateTaskFromScheduleEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TaskDetailsLoadedState) return;

    emit(TaskDetailsCreatingTaskState(currentState.task));

    final request = CreateTaskFromScheduleRequestEntity(
      scheduleId: event.scheduleId,
      scheduleEventId: event.scheduleEventId,
    );

    final result = await _createTaskFromScheduleUseCase(request);

    result.fold(
      (failure) {
        emit(TaskDetailsTaskCreationErrorState(
            'Erro ao criar tarefa: ${failure.toString()}'));
      },
      (response) {
        emit(TaskDetailsTaskCreatedState(
          taskId: response.task.id,
          eventId: response.event.id,
        ));
      },
    );
  }
}
