import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class TabChangedEvent extends DashboardEvent {
  final int tabIndex;

  const TabChangedEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();
}

class FiltersUpdatedEvent extends DashboardEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, dynamic>? appliedFilters;

  const FiltersUpdatedEvent({
    this.startDate,
    this.endDate,
    this.appliedFilters,
  });

  @override
  List<Object?> get props => [startDate, endDate, appliedFilters];
}

class LoadInitialDataEvent extends DashboardEvent {
  const LoadInitialDataEvent();
}
