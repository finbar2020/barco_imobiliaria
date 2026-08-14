import 'package:essentials/essentials.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class DashboardInitialState extends DashboardState {}

/// Estado de loading geral
class DashboardLoadingState extends DashboardState {}

/// Estado com dados carregados
class DashboardLoadedState extends DashboardState {
  final int currentTabIndex;
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, dynamic>? appliedFilters;
  final bool hasAppliedFilters;

  const DashboardLoadedState({
    required this.currentTabIndex,
    this.startDate,
    this.endDate,
    this.appliedFilters,
    this.hasAppliedFilters = false,
  });

  @override
  List<Object?> get props => [
        currentTabIndex,
        startDate,
        endDate,
        appliedFilters,
        hasAppliedFilters,
      ];

  DashboardLoadedState copyWith({
    int? currentTabIndex,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? appliedFilters,
    bool? hasAppliedFilters,
  }) {
    return DashboardLoadedState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      appliedFilters: appliedFilters ?? this.appliedFilters,
      hasAppliedFilters: hasAppliedFilters ?? this.hasAppliedFilters,
    );
  }
}

/// Estado de erro
class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState(this.message);

  @override
  List<Object> get props => [message];
}
