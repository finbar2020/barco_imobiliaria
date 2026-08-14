import 'package:equatable/equatable.dart';

import '../../../domain/entity/maintenance_management_entity.dart';

abstract class MaintenanceManagementState extends Equatable {
  const MaintenanceManagementState();

  @override
  List<Object?> get props => [];
}

class MaintenanceManagementLoadingState extends MaintenanceManagementState {
  const MaintenanceManagementLoadingState();
}

class MaintenanceManagementErrorState extends MaintenanceManagementState {
  final String message;

  const MaintenanceManagementErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MaintenanceManagementLoadedState extends MaintenanceManagementState {
  final CondominiumInfoEntity data;

  const MaintenanceManagementLoadedState(this.data);

  @override
  List<Object?> get props => [data];
}

class MaintenanceManagementWarningModalState
    extends MaintenanceManagementState {
  final CondominiumInfoEntity entity;

  const MaintenanceManagementWarningModalState(this.entity);

  @override
  List<Object?> get props => [entity];
}
