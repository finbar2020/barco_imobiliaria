import '../../../domain/entity/maintenance_task_event_entity.dart';

abstract class AgendaTasksState {}

class AgendaTasksInitialState extends AgendaTasksState {}

class AgendaTasksLoadingState extends AgendaTasksState {}

class AgendaTasksLoadedState extends AgendaTasksState {
  final List<MaintenanceTaskEventEntity> tasks;
  final DateTime selectedDate;
  final String orderBy;
  final int totalTasks;

  AgendaTasksLoadedState({
    required this.tasks,
    required this.selectedDate,
    required this.orderBy,
    required this.totalTasks,
  });

  AgendaTasksLoadedState copyWith({
    List<MaintenanceTaskEventEntity>? tasks,
    DateTime? selectedDate,
    String? orderBy,
    int? totalTasks,
  }) {
    return AgendaTasksLoadedState(
      tasks: tasks ?? this.tasks,
      selectedDate: selectedDate ?? this.selectedDate,
      orderBy: orderBy ?? this.orderBy,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }
}

class AgendaTasksEmptyState extends AgendaTasksState {
  final DateTime selectedDate;
  final String message;

  AgendaTasksEmptyState({
    required this.selectedDate,
    required this.message,
  });
}

class AgendaTasksErrorState extends AgendaTasksState {
  final String message;
  final DateTime? selectedDate;

  AgendaTasksErrorState({
    required this.message,
    this.selectedDate,
  });
}
