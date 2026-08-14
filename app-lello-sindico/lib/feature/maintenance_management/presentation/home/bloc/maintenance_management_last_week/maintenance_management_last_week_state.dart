// ignore_for_file: unused_import

import 'package:essentials/essentials.dart';

import '../../../enums/efficiency_scope_enum.dart';
import '../../../../domain/entity/efficiency_entity.dart';
import 'maintenance_management_last_week_event.dart';

abstract class MaintenanceManagementLastWeekState extends Equatable {
  const MaintenanceManagementLastWeekState();

  @override
  List<Object?> get props => [];
}

class MaintenanceManagementLastWeekInitialState
    extends MaintenanceManagementLastWeekState {}

class MaintenanceManagementLastWeekLoadingState
    extends MaintenanceManagementLastWeekState {}

class MaintenanceManagementLastWeekLoadedState
    extends MaintenanceManagementLastWeekState {
  final List<EfficiencyItem> responsibles;
  final List<EfficiencyItem> groups;
  final EfficiencyScope currentScope;
  final String searchQuery;
  final TaskSummaryEntity? taskSummary;
  final bool isLoadingList; // Flag para indicar loading apenas da lista

  const MaintenanceManagementLastWeekLoadedState({
    required this.responsibles,
    required this.groups,
    required this.currentScope,
    required this.searchQuery,
    this.taskSummary,
    this.isLoadingList = false,
  });

  @override
  List<Object?> get props => [
        responsibles,
        groups,
        currentScope,
        searchQuery,
        taskSummary,
        isLoadingList
      ];

  MaintenanceManagementLastWeekLoadedState copyWith({
    List<EfficiencyItem>? responsibles,
    List<EfficiencyItem>? groups,
    EfficiencyScope? currentScope,
    String? searchQuery,
    TaskSummaryEntity? taskSummary,
    bool? isLoadingList,
  }) {
    return MaintenanceManagementLastWeekLoadedState(
      responsibles: responsibles ?? this.responsibles,
      groups: groups ?? this.groups,
      currentScope: currentScope ?? this.currentScope,
      searchQuery: searchQuery ?? this.searchQuery,
      taskSummary: taskSummary ?? this.taskSummary,
      isLoadingList: isLoadingList ?? this.isLoadingList,
    );
  }
}

class MaintenanceManagementLastWeekErrorState
    extends MaintenanceManagementLastWeekState {
  final String message;

  const MaintenanceManagementLastWeekErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class EfficiencyItem extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final int completed;
  final int pending;
  final int inProgress;
  final String avatarColor;

  const EfficiencyItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.avatarColor,
  });

  @override
  List<Object?> get props =>
      [id, title, subtitle, completed, pending, inProgress, avatarColor];
}
