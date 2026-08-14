import 'package:equatable/equatable.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_management_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_events_response_entity.dart';

abstract class MaintenanceManagementEvent extends Equatable {
  const MaintenanceManagementEvent();

  @override
  List<Object?> get props => [];
}

class MaintenanceManagementLoadingEvent extends MaintenanceManagementEvent {
  const MaintenanceManagementLoadingEvent();
}

class MaintenanceManagementLoadedEvent extends MaintenanceManagementEvent {
  final CondominiumInfoEntity data;

  const MaintenanceManagementLoadedEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class MaintenanceManagementTaskEventsLoadedEvent
    extends MaintenanceManagementEvent {
  final MaintenanceTaskEventsResponseEntity data;

  const MaintenanceManagementTaskEventsLoadedEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class MaintenanceManagementErrorEvent extends MaintenanceManagementEvent {
  final String error;

  const MaintenanceManagementErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}

class MaintenanceManagementWarningModalEvent
    extends MaintenanceManagementEvent {
  final CondominiumInfoEntity entity;

  const MaintenanceManagementWarningModalEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}
