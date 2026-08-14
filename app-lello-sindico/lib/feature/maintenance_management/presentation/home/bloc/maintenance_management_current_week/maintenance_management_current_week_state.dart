import 'package:equatable/equatable.dart';

import '../../../../domain/entity/maintenance_task_event_entity.dart';
import '../../../../domain/entity/efficiency_entity.dart';
import '../../../enums/efficiency_scope_enum.dart';

abstract class MaintenanceManagementCurrentWeekState extends Equatable {
  const MaintenanceManagementCurrentWeekState();

  @override
  List<Object?> get props => [];
}

class MaintenanceManagementCurrentWeekInitialState
    extends MaintenanceManagementCurrentWeekState {
  const MaintenanceManagementCurrentWeekInitialState();
}

class MaintenanceManagementCurrentWeekLoadingState
    extends MaintenanceManagementCurrentWeekState {
  const MaintenanceManagementCurrentWeekLoadingState();
}

class MaintenanceManagementCurrentWeekLoadedState
    extends MaintenanceManagementCurrentWeekState {
  final TaskSummaryEntity taskSummaryDay;
  final List<MaintenanceTaskEventEntity> events;
  final EfficiencyScope currentScope;

  const MaintenanceManagementCurrentWeekLoadedState({
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

  @override
  List<Object?> get props => [taskSummaryDay, events, currentScope];
}

class MaintenanceManagementCurrentWeekErrorState
    extends MaintenanceManagementCurrentWeekState {
  final String message;

  const MaintenanceManagementCurrentWeekErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
