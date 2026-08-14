import 'package:equatable/equatable.dart';

import '../../enums/efficiency_scope_enum.dart';

abstract class VisualizeReportsEvent extends Equatable {
  const VisualizeReportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFormularyByMonthEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;

  const LoadFormularyByMonthEvent({
    required this.dtStart,
    required this.untilDate,
  });

  @override
  List<Object?> get props => [dtStart, untilDate];
}

class LoadFormularyByMonthWithFiltersEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  const LoadFormularyByMonthWithFiltersEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });

  @override
  List<Object?> get props => [
        dtStart,
        untilDate,
        responsibleIds,
        assetIds,
        localIds,
        typeTask,
        status,
      ];
}

class ResetReportsEvent extends VisualizeReportsEvent {
  const ResetReportsEvent();
}

class LoadReportsEfficiencyEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  const LoadReportsEfficiencyEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });

  @override
  List<Object?> get props => [
        dtStart,
        untilDate,
        responsibleIds,
        assetIds,
        localIds,
        typeTask,
        status,
      ];
}

class SearchReportsEfficiencyEvent extends VisualizeReportsEvent {
  final String query;

  const SearchReportsEfficiencyEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ChangeReportsEfficiencyScopeEvent extends VisualizeReportsEvent {
  final EfficiencyScope scope;

  const ChangeReportsEfficiencyScopeEvent(this.scope);

  @override
  List<Object?> get props => [scope];
}

class LoadTaskBySectorEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  const LoadTaskBySectorEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });

  @override
  List<Object?> get props => [
        dtStart,
        untilDate,
        responsibleIds,
        assetIds,
        localIds,
        typeTask,
        status,
      ];
}

class LoadTaskByMonthEvent extends VisualizeReportsEvent {
  final String dtStart;
  final String untilDate;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  const LoadTaskByMonthEvent({
    required this.dtStart,
    required this.untilDate,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });

  @override
  List<Object?> get props => [
        dtStart,
        untilDate,
        responsibleIds,
        assetIds,
        localIds,
        typeTask,
        status,
      ];
}
