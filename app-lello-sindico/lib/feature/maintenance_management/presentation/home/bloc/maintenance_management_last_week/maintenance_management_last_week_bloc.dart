import 'package:essentials/essentials.dart';

import '../../../../adapters/efficiency_bloc_adapter.dart';
import '../../../../domain/repository/maintenance_management_repository.dart';
import '../../../enums/efficiency_scope_enum.dart';
import 'maintenance_management_last_week_event.dart';
import 'maintenance_management_last_week_state.dart';

class MaintenanceManagementLastWeekBloc extends Bloc<
    MaintenanceManagementLastWeekEvent, MaintenanceManagementLastWeekState> {
  final MaintenanceManagementRepository repository;

  MaintenanceManagementLastWeekBloc(this.repository)
      : super(MaintenanceManagementLastWeekInitialState()) {
    on<FetchMaintenanceLastWeekEfficiencyEvent>(_onFetchEfficiencyData);
    on<SearchEfficiencyEvent>(_onSearchEfficiency);
    on<ChangeEfficiencyScopeEvent>(_onChangeScope);
  }

  void fetchEfficiencyData() {
    add(FetchMaintenanceLastWeekEfficiencyEvent(
      startDate: _getLastWeekStart(),
      endDate: _getLastWeekEnd(),
    ));
  }

  void searchEfficiency(String query) {
    add(SearchEfficiencyEvent(query));
  }

  void changeScope(EfficiencyScope scope) {
    add(ChangeEfficiencyScopeEvent(scope));
  }

  Future<void> _onFetchEfficiencyData(
    FetchMaintenanceLastWeekEfficiencyEvent event,
    Emitter<MaintenanceManagementLastWeekState> emit,
  ) async {
    final scope = state is MaintenanceManagementLastWeekLoadedState
        ? (state as MaintenanceManagementLastWeekLoadedState).currentScope
        : EfficiencyScope.responsibles;

    emit(MaintenanceManagementLastWeekLoadingState());

    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      final startDate = dateFormat.format(event.startDate);
      final endDate = dateFormat.format(event.endDate);
      final currentDate = dateFormat.format(DateTime.now());

      final result = await repository.getMaintenanceTasksEfficiency(
        dtStart: startDate,
        untilDate: endDate,
        typeTask: ['ORDEM_SERVICO', 'ROTINA'],
        dayCurrent: currentDate,
        procedureGroupLabels: [],
        procedureGroupIds: [],
        responsibleIds: [],
        displayBy:
            scope == EfficiencyScope.responsibles ? 'RESPONSAVEL' : 'GRUPO',
        status: [],
      );

      result.fold(
        (failure) =>
            emit(MaintenanceManagementLastWeekErrorState(failure.toString())),
        (responsiblesEntity) {
          final items = responsiblesEntity.toBlocItems(avatarColor: '#4CAF50');

          emit(MaintenanceManagementLastWeekLoadedState(
            responsibles: items,
            groups: const [],
            currentScope: scope,
            searchQuery: '',
            taskSummary: responsiblesEntity.taskSummary,
            isLoadingList: false,
          ));
        },
      );
    } catch (e) {
      emit(MaintenanceManagementLastWeekErrorState(e.toString()));
    }
  }

  Future<void> _onSearchEfficiency(
    SearchEfficiencyEvent event,
    Emitter<MaintenanceManagementLastWeekState> emit,
  ) async {
    if (state is MaintenanceManagementLastWeekLoadedState) {
      final currentState = state as MaintenanceManagementLastWeekLoadedState;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  Future<void> _onChangeScope(
    ChangeEfficiencyScopeEvent event,
    Emitter<MaintenanceManagementLastWeekState> emit,
  ) async {
    if (state is MaintenanceManagementLastWeekLoadedState) {
      final currentState = state as MaintenanceManagementLastWeekLoadedState;

      // Emite o estado com flag isLoadingList = true
      emit(currentState.copyWith(
        currentScope: event.scope,
        isLoadingList: true,
      ));

      try {
        final dateFormat = DateFormat('dd/MM/yyyy');
        final startDate = dateFormat.format(_getLastWeekStart());
        final endDate = dateFormat.format(_getLastWeekEnd());
        final currentDate = dateFormat.format(DateTime.now());

        final result = await repository.getMaintenanceTasksEfficiency(
          dtStart: startDate,
          untilDate: endDate,
          typeTask: ['ORDEM_SERVICO', 'ROTINA'],
          dayCurrent: currentDate,
          procedureGroupLabels: [],
          procedureGroupIds: [],
          responsibleIds: [],
          displayBy: event.scope == EfficiencyScope.responsibles
              ? 'RESPONSAVEL'
              : 'GRUPO',
          status: [],
        );

        result.fold(
          (failure) {
            emit(MaintenanceManagementLastWeekErrorState(failure.toString()));
          },
          (entity) {
            final items = entity.toBlocItems(avatarColor: '#4CAF50');

            emit(MaintenanceManagementLastWeekLoadedState(
              responsibles: event.scope == EfficiencyScope.responsibles
                  ? items
                  : currentState.responsibles,
              groups: event.scope == EfficiencyScope.groups
                  ? items
                  : currentState.groups,
              currentScope: event.scope,
              searchQuery: currentState.searchQuery,
              taskSummary: currentState.taskSummary,
              isLoadingList: false,
            ));
          },
        );
      } catch (e) {
        emit(MaintenanceManagementLastWeekErrorState(e.toString()));
      }
    }
  }

  DateTime _getLastWeekStart() {
    final now = DateTime.now();
    final daysToSubtract = now.weekday + 6;
    return now.subtract(Duration(days: daysToSubtract));
  }

  DateTime _getLastWeekEnd() {
    final lastWeekStart = _getLastWeekStart();
    return lastWeekStart.add(const Duration(days: 6));
  }
}
