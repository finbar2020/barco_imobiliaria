import '../../../../condominium/domain/entity/condominium.dart';
import '../../../domain/entity/maintenance_management_entity.dart';

abstract class MaintenanceManagementState {}

class MaintenanceManagementIdleState extends MaintenanceManagementState {}

class MaintenanceManagementLoadingState extends MaintenanceManagementState {}

class MaintenanceManagementErrorState extends MaintenanceManagementState {
  final String message;

  MaintenanceManagementErrorState(this.message);
}

class MaintenanceManagementLoadedState extends MaintenanceManagementState {
  final CondominiumInfoEntity data;

  MaintenanceManagementLoadedState(this.data);
}

class MaintenanceManagementWarningModalState
    extends MaintenanceManagementState {
  final CondominiumInfoEntity entity;

  MaintenanceManagementWarningModalState(this.entity);
}
