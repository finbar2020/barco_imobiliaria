import '../../../domain/entity/task_details_entity.dart';
import '../../../domain/entity/task_formularies_entity.dart';
import '../../../domain/entity/task_files_entity.dart';
import 'task_details_event.dart';

abstract class TaskDetailsState {
  const TaskDetailsState();
}

class TaskDetailsInitialState extends TaskDetailsState {}

class TaskDetailsLoadingState extends TaskDetailsState {}

class TaskDetailsLoadedState extends TaskDetailsState {
  final TaskDetailsEntity task;
  final List<TaskFormularyEntity> formularies;
  final List<TaskFileEntity> files;
  final TaskDetailsTabType selectedTab;
  final bool isLoadingFormularies;
  final bool isLoadingFiles;

  const TaskDetailsLoadedState({
    required this.task,
    this.formularies = const [],
    this.files = const [],
    this.selectedTab = TaskDetailsTabType.steps,
    this.isLoadingFormularies = false,
    this.isLoadingFiles = false,
  });

  TaskDetailsLoadedState copyWith({
    TaskDetailsEntity? task,
    List<TaskFormularyEntity>? formularies,
    List<TaskFileEntity>? files,
    TaskDetailsTabType? selectedTab,
    bool? isLoadingFormularies,
    bool? isLoadingFiles,
  }) {
    return TaskDetailsLoadedState(
      task: task ?? this.task,
      formularies: formularies ?? this.formularies,
      files: files ?? this.files,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoadingFormularies: isLoadingFormularies ?? this.isLoadingFormularies,
      isLoadingFiles: isLoadingFiles ?? this.isLoadingFiles,
    );
  }
}

class TaskDetailsErrorState extends TaskDetailsState {
  final String message;

  const TaskDetailsErrorState(this.message);
}

class TaskDetailsCreatingTaskState extends TaskDetailsState {
  final TaskDetailsEntity task;

  const TaskDetailsCreatingTaskState(this.task);
}

class TaskDetailsTaskCreatedState extends TaskDetailsState {
  final String taskId;
  final String eventId;

  const TaskDetailsTaskCreatedState({
    required this.taskId,
    required this.eventId,
  });
}

class TaskDetailsTaskCreationErrorState extends TaskDetailsState {
  final String message;

  const TaskDetailsTaskCreationErrorState(this.message);
}
