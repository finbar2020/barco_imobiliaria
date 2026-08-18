import '../../../../domain/entity/maintenance_task_event_entity.dart';
import '../../../../domain/entity/efficiency_entity.dart';
import '../../../enums/efficiency_scope_enum.dart';

abstract class MaintenanceManagementCurrentWeekState {}

class MaintenanceManagementCurrentWeekInitialState
    extends MaintenanceManagementCurrentWeekState {}

class MaintenanceManagementCurrentWeekLoadingState
    extends MaintenanceManagementCurrentWeekState {}

class MaintenanceManagementCurrentWeekLoadedState
    extends MaintenanceManagementCurrentWeekState {
  final TaskSummaryEntity taskSummaryDay;
  final List<MaintenanceTaskEventEntity> events;
  final EfficiencyScope currentScope;

  MaintenanceManagementCurrentWeekLoadedState({
    required this.taskSummaryDay,
    required this.events,
    this.currentScope = EfficiencyScope.responsibles,
  });

  MaintenanceManagementCurrentWeekLoadedState copyWith({
    TaskSummaryEntity? taskSummaryDay,
    TaskSummaryEntity? taskSummaryWeek,
    List<MaintenanceTaskEventEntity>? events,
    EfficiencyScope? currentScope,
  }) {
    return MaintenanceManagementCurrentWeekLoadedState(
      taskSummaryDay: taskSummaryDay ?? this.taskSummaryDay,
      events: events ?? this.events,
      currentScope: currentScope ?? this.currentScope,
    );
  }
}

class MaintenanceManagementCurrentWeekErrorState
    extends MaintenanceManagementCurrentWeekState {
  final String message;

  MaintenanceManagementCurrentWeekErrorState({
    required this.message,
  });
}
