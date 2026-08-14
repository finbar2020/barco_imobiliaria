
import 'package:essentials/essentials.dart';

import '../../../enums/efficiency_scope_enum.dart';

abstract class MaintenanceManagementLastWeekEvent extends Equatable {
  const MaintenanceManagementLastWeekEvent();

  @override
  List<Object?> get props => [];
}

class FetchMaintenanceLastWeekEfficiencyEvent extends MaintenanceManagementLastWeekEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FetchMaintenanceLastWeekEfficiencyEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class SearchEfficiencyEvent extends MaintenanceManagementLastWeekEvent {
  final String query;

  const SearchEfficiencyEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ChangeEfficiencyScopeEvent extends MaintenanceManagementLastWeekEvent {
  final EfficiencyScope scope;

  const ChangeEfficiencyScopeEvent(this.scope);

  @override
  List<Object?> get props => [scope];
}