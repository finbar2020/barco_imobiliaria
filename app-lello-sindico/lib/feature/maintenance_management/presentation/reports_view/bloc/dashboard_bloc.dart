import 'package:essentials/essentials.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitialState()) {
    on<LoadInitialDataEvent>(_onLoadInitialData);
    on<TabChangedEvent>(_onTabChanged);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<FiltersUpdatedEvent>(_onFiltersUpdated);
  }

  void _onLoadInitialData(
    LoadInitialDataEvent event,
    Emitter<DashboardState> emit,
  ) {
    // Configuração inicial - 30 dias atrás até hoje
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));

    emit(DashboardLoadedState(
      currentTabIndex: 0, // Inicia na aba "Rotina"
      startDate: startDate,
      endDate: endDate,
    ));
  }

  void _onTabChanged(
    TabChangedEvent event,
    Emitter<DashboardState> emit,
  ) {
    final currentState = state;
    if (currentState is DashboardLoadedState) {
      emit(currentState.copyWith(currentTabIndex: event.tabIndex));
    }
  }

  void _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) {
    final currentState = state;
    if (currentState is DashboardLoadedState) {
      // Reemite o mesmo estado para forçar rebuild dos consumidores.
      emit(currentState);
    }
  }

  void _onFiltersUpdated(
    FiltersUpdatedEvent event,
    Emitter<DashboardState> emit,
  ) {
    final currentState = state;
    if (currentState is DashboardLoadedState) {
      final hasFilters =
          event.appliedFilters != null && event.appliedFilters!.isNotEmpty;

      emit(currentState.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
        appliedFilters: event.appliedFilters,
        hasAppliedFilters: hasFilters,
      ));
    }
  }

  /// Método helper para disparar reload de todos os gráficos
  void reloadAllCharts() {
    add(const RefreshDashboardEvent());
  }

  /// Método helper para mudar aba
  void changeTab(int tabIndex) {
    add(TabChangedEvent(tabIndex));
  }

  /// Método helper para atualizar filtros
  void updateFilters({
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? appliedFilters,
  }) {
    add(FiltersUpdatedEvent(
      startDate: startDate,
      endDate: endDate,
      appliedFilters: appliedFilters,
    ));
  }
}
