abstract class DashboardEvent {}

class TabChangedEvent extends DashboardEvent {
  final int tabIndex;

  TabChangedEvent(this.tabIndex);
}

class RefreshDashboardEvent extends DashboardEvent {}

class FiltersUpdatedEvent extends DashboardEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, dynamic>? appliedFilters;

  FiltersUpdatedEvent({
    this.startDate,
    this.endDate,
    this.appliedFilters,
  });
}

class LoadInitialDataEvent extends DashboardEvent {}
