import 'package:essentials/essentials.dart';

import '../../../../domain/use_cases/get_maintenance_task_events_use_case.dart';
import '../../../enums/efficiency_scope_enum.dart';
import 'maintenance_management_current_week_bloc.dart';
import 'maintenance_management_current_week_event.dart';
import 'maintenance_management_current_week_state.dart';

class MaintenanceManagementCurrentWeekBlocImpl
    extends MaintenanceManagementCurrentWeekBloc {
  final GetMaintenanceTaskEventsUseCase _getMaintenanceTaskEventsUseCase;

  MaintenanceManagementCurrentWeekBlocImpl(
    GetMaintenanceTaskEventsUseCase getMaintenanceTaskEventsUseCase,
  ) : _getMaintenanceTaskEventsUseCase = getMaintenanceTaskEventsUseCase {
    on<FetchMaintenanceTaskEventsEvent>(_onFetchMaintenanceTaskEvents);
    on<ChangeEfficiencyScopeEvent>(_onChangeScope);
  }

  Future<void> _onFetchMaintenanceTaskEvents(
    FetchMaintenanceTaskEventsEvent event,
    Emitter<MaintenanceManagementCurrentWeekState> emit,
  ) async {
    emit(MaintenanceManagementCurrentWeekLoadingState());

    try {
      final params = GetMaintenanceTaskEventsParams(
        dtStart: event.dtStart,
        untilDate: event.untilDate,
        typeTask: event.typeTask,
        status: event.status,
        dayCurrent: event.dayCurrent,
        procedureGroupLabels: event.procedureGroupLabels,
        displayBy: event.displayBy,
        assetIds: event.assetIds,
        localIds: event.localIds,
        responsibleIds: event.responsibleIds,
        pageName: event.pageName,
      );

      final result = await _getMaintenanceTaskEventsUseCase(params);

      result.fold(
        (failure) {
          emit(MaintenanceManagementCurrentWeekErrorState(
            message: failure.toString(),
          ));
        },
        (response) {
          emit(MaintenanceManagementCurrentWeekLoadedState(
            taskSummaryDay: response.taskSummaryDay,
            events: response.events,
            currentScope: EfficiencyScope.responsibles,
          ));
        },
      );
    } catch (e) {
      emit(MaintenanceManagementCurrentWeekErrorState(
        message: e.toString(),
      ));
    }
  }

  @override
  void changeScope(EfficiencyScope scope) {
    add(ChangeEfficiencyScopeEvent(scope));
  }

  Future<void> _onChangeScope(
    ChangeEfficiencyScopeEvent event,
    Emitter<MaintenanceManagementCurrentWeekState> emit,
  ) async {
    if (state is MaintenanceManagementCurrentWeekLoadedState) {
      final currentState = state as MaintenanceManagementCurrentWeekLoadedState;
      emit(currentState.copyWith(currentScope: event.scope));
    }
  }
}
