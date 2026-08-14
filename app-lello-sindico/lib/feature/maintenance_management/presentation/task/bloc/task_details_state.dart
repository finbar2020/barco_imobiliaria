import 'package:equatable/equatable.dart';
import '../../../domain/entity/task_details_entity.dart';
import '../../../domain/entity/task_formularies_entity.dart';
import '../../../domain/entity/task_files_entity.dart';
import 'task_details_event.dart';

abstract class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object?> get props => [];
}

class TaskDetailsInitialState extends TaskDetailsState {
  const TaskDetailsInitialState();
}

class TaskDetailsLoadingState extends TaskDetailsState {
  const TaskDetailsLoadingState();
}

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

  @override
  List<Object?> get props => [
        task,
        formularies,
        files,
        selectedTab,
        isLoadingFormularies,
        isLoadingFiles,
      ];
}

class TaskDetailsErrorState extends TaskDetailsState {
  final String message;

  const TaskDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskDetailsCreatingTaskState extends TaskDetailsState {
  final TaskDetailsEntity task;

  const TaskDetailsCreatingTaskState(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDetailsTaskCreatedState extends TaskDetailsState {
  final String taskId;
  final String eventId;

  const TaskDetailsTaskCreatedState({
    required this.taskId,
    required this.eventId,
  });

  @override
  List<Object?> get props => [taskId, eventId];
}

class TaskDetailsTaskCreationErrorState extends TaskDetailsState {
  final String message;

  const TaskDetailsTaskCreationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
