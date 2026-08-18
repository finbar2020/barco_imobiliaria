import '../../enums/efficiency_scope_enum.dart';

abstract class VisualizeReportsEvent {}

class LoadFormularyByMonthEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;

  LoadFormularyByMonthEvent({
    required this.dtStart,
    required this.untilDate,
  });
}

class LoadFormularyByMonthWithFiltersEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  LoadFormularyByMonthWithFiltersEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });
}

class ResetReportsEvent extends VisualizeReportsEvent {}

class LoadReportsEfficiencyEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  LoadReportsEfficiencyEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });
}

class SearchReportsEfficiencyEvent extends VisualizeReportsEvent {
  final String query;

  SearchReportsEfficiencyEvent(this.query);
}

class ChangeReportsEfficiencyScopeEvent extends VisualizeReportsEvent {
  final EfficiencyScope scope;

  ChangeReportsEfficiencyScopeEvent(this.scope);
}

class LoadTaskBySectorEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  LoadTaskBySectorEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });
}

class LoadTaskByMonthEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  LoadTaskByMonthEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });
}
