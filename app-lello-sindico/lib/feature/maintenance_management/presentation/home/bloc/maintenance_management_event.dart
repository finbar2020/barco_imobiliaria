import 'package:lello/feature/maintenance_management/domain/entity/maintenance_management_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_events_response_entity.dart';

abstract class MaintenanceManagementEvent {}

class MaintenanceManagementLoadingEvent extends MaintenanceManagementEvent {}

class MaintenanceManagementLoadedEvent extends MaintenanceManagementEvent {
  final CondominiumInfoEntity data;

  MaintenanceManagementLoadedEvent(this.data);
}

class MaintenanceManagementTaskEventsLoadedEvent
    extends MaintenanceManagementEvent {
  final MaintenanceTaskEventsResponseEntity data;

  MaintenanceManagementTaskEventsLoadedEvent(this.data);
}

class MaintenanceManagementErrorEvent extends MaintenanceManagementEvent {
  final String error;

  MaintenanceManagementErrorEvent(this.error);
}

class MaintenanceManagementWarningModalEvent
    extends MaintenanceManagementEvent {
  final CondominiumInfoEntity entity;

  MaintenanceManagementWarningModalEvent(this.entity);
}
