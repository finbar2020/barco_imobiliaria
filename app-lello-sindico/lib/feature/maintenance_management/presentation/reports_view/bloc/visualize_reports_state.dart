import '../../../domain/entity/formulary_by_month_response_entity.dart';
import '../../../domain/entity/task_by_month_response_entity.dart';
import '../../../domain/entity/efficiency_entity.dart';
import '../../../domain/entity/task_by_sector_entity.dart';
import '../../enums/efficiency_scope_enum.dart';
import '../../home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart' as last_week_state;

abstract class VisualizeReportsState {}

class VisualizeReportsInitialState extends VisualizeReportsState {}

class VisualizeReportsLoadingState extends VisualizeReportsState {}

class VisualizeReportsLoadedState extends VisualizeReportsState {
  final FormularyByMonthResponseEntity formularyData;
  final TaskByMonthResponseEntity? taskByMonthData;
  final List<last_week_state.EfficiencyItem> responsibles;
  final List<last_week_state.EfficiencyItem> groups;
  final EfficiencyScope currentScope;
  final String searchQuery;
  final TaskSummaryEntity? taskSummary;
  final List<TaskBySectorDataEntity>? taskBySectorData;
  final bool isTaskBySectorLoading;
  final String? taskBySectorError;
  final bool isTaskByMonthLoading;
  final String? taskByMonthError;

  VisualizeReportsLoadedState({
    required this.formularyData,
    this.taskByMonthData,
    this.responsibles = const [],
    this.groups = const [],
    this.currentScope = EfficiencyScope.responsibles,
    this.searchQuery = '',
    this.taskSummary,
    this.taskBySectorData,
    this.isTaskBySectorLoading = false,
    this.taskBySectorError,
    this.isTaskByMonthLoading = false,
    this.taskByMonthError,
  });

  VisualizeReportsLoadedState copyWith({
    FormularyByMonthResponseEntity? formularyData,
    TaskByMonthResponseEntity? taskByMonthData,
    List<last_week_state.EfficiencyItem>? responsibles,
    List<last_week_state.EfficiencyItem>? groups,
    EfficiencyScope? currentScope,
    String? searchQuery,
    TaskSummaryEntity? taskSummary,
    List<TaskBySectorDataEntity>? taskBySectorData,
    bool? isTaskBySectorLoading,
    String? taskBySectorError,
    bool? isTaskByMonthLoading,
    String? taskByMonthError,
  }) {
    return VisualizeReportsLoadedState(
      formularyData: formularyData ?? this.formularyData,
      taskByMonthData: taskByMonthData ?? this.taskByMonthData,
      responsibles: responsibles ?? this.responsibles,
      groups: groups ?? this.groups,
      currentScope: currentScope ?? this.currentScope,
      searchQuery: searchQuery ?? this.searchQuery,
      taskSummary: taskSummary ?? this.taskSummary,
      taskBySectorData: taskBySectorData ?? this.taskBySectorData,
      isTaskBySectorLoading: isTaskBySectorLoading ?? this.isTaskBySectorLoading,
      taskBySectorError: taskBySectorError ?? this.taskBySectorError,
      isTaskByMonthLoading: isTaskByMonthLoading ?? this.isTaskByMonthLoading,
      taskByMonthError: taskByMonthError ?? this.taskByMonthError,
    );
  }
}

class VisualizeReportsErrorState extends VisualizeReportsState {
  final String message;

  VisualizeReportsErrorState({
    required this.message,
  });
}
