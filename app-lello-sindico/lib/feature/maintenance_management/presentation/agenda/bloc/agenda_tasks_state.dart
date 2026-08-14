import 'package:equatable/equatable.dart';
import '../../../domain/entity/maintenance_task_event_entity.dart';

abstract class AgendaTasksState extends Equatable {
  const AgendaTasksState();

  @override
  List<Object?> get props => [];
}

class AgendaTasksInitialState extends AgendaTasksState {
  const AgendaTasksInitialState();
}

class AgendaTasksLoadingState extends AgendaTasksState {
  const AgendaTasksLoadingState();
}

class AgendaTasksLoadedState extends AgendaTasksState {
  final List<MaintenanceTaskEventEntity> tasks;
  final DateTime selectedDate;
  final String orderBy;
  final int totalTasks;

  const AgendaTasksLoadedState({
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

  @override
  List<Object?> get props => [tasks, selectedDate, orderBy, totalTasks];
}

class AgendaTasksEmptyState extends AgendaTasksState {
  final DateTime selectedDate;
  final String message;

  const AgendaTasksEmptyState({
    required this.selectedDate,
    required this.message,
  });

  @override
  List<Object?> get props => [selectedDate, message];
}

class AgendaTasksErrorState extends AgendaTasksState {
  final String message;
  final DateTime? selectedDate;

  const AgendaTasksErrorState({
    required this.message,
    this.selectedDate,
  });

  @override
  List<Object?> get props => [message, selectedDate];
}
