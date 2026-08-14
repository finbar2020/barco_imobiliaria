import 'package:equatable/equatable.dart';

import '../../../enums/efficiency_scope_enum.dart';

abstract class MaintenanceManagementCurrentWeekEvent extends Equatable {
  const MaintenanceManagementCurrentWeekEvent();

  @override
  List<Object?> get props => [];
}

class FetchMaintenanceTaskEventsEvent
    extends MaintenanceManagementCurrentWeekEvent {
  final DateTime dtStart;
  final DateTime untilDate;
  final List<String> typeTask;
  final List<String> status;
  final DateTime dayCurrent;
  final List<String>? procedureGroupLabels;
  final String? displayBy;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? responsibleIds;
  final String? pageName;

  const FetchMaintenanceTaskEventsEvent({
    required this.dtStart,
    required this.untilDate,
    required this.typeTask,
    required this.status,
    required this.dayCurrent,
    this.procedureGroupLabels,
    this.displayBy,
    this.assetIds,
    this.localIds,
    this.responsibleIds,
    this.pageName,
  });

  @override
  List<Object?> get props => [
        dtStart,
        untilDate,
        typeTask,
        status,
        dayCurrent,
        procedureGroupLabels,
        displayBy,
        assetIds,
        localIds,
        responsibleIds,
        pageName,
      ];
}

class ChangeEfficiencyScopeEvent extends MaintenanceManagementCurrentWeekEvent {
  final EfficiencyScope scope;

  const ChangeEfficiencyScopeEvent(this.scope);

  @override
  List<Object?> get props => [scope];
}
