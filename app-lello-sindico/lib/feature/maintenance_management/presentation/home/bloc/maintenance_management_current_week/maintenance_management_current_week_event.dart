import '../../../enums/efficiency_scope_enum.dart';

abstract class MaintenanceManagementCurrentWeekEvent {}

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

  FetchMaintenanceTaskEventsEvent({
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
}

class ChangeEfficiencyScopeEvent extends MaintenanceManagementCurrentWeekEvent {
  final EfficiencyScope scope;

  ChangeEfficiencyScopeEvent(this.scope);
}
