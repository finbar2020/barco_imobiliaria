import 'package:essentials/essentials.dart';
import '../../../domain/use_cases/get_formulary_by_month_use_case.dart';
import '../../../domain/use_cases/get_task_by_month_use_case.dart';
import '../../../domain/use_cases/get_task_by_sector_use_case.dart';
import '../../../domain/repository/maintenance_management_repository.dart';
import '../../../domain/entity/efficiency_entity.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../../domain/entity/formulary_by_month_response_entity.dart';
import '../../../adapters/efficiency_bloc_adapter.dart';
import '../../enums/efficiency_scope_enum.dart';
import '../../home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart'
    as last_week_state;
import 'visualize_reports_bloc.dart';
import 'visualize_reports_event.dart';
import 'visualize_reports_state.dart';

class VisualizeReportsBlocImpl extends VisualizeReportsBloc {
  final GetFormularyByMonthUseCase _getFormularyByMonthUseCase;
  final GetTaskByMonthUseCase _getTaskByMonthUseCase;
  final GetTaskBySectorUseCase _getTaskBySectorUseCase;
  final MaintenanceManagementRepository _repository;

  VisualizeReportsBlocImpl(
    GetFormularyByMonthUseCase getFormularyByMonthUseCase,
    GetTaskByMonthUseCase getTaskByMonthUseCase,
    GetTaskBySectorUseCase getTaskBySectorUseCase,
    MaintenanceManagementRepository repository,
  )   : _getFormularyByMonthUseCase = getFormularyByMonthUseCase,
        _getTaskByMonthUseCase = getTaskByMonthUseCase,
        _getTaskBySectorUseCase = getTaskBySectorUseCase,
        _repository = repository {
    on<LoadFormularyByMonthEvent>(_onLoadFormularyByMonth);
    on<LoadFormularyByMonthWithFiltersEvent>(
        _onLoadFormularyByMonthWithFilters);
    on<ResetReportsEvent>(_onResetReports);
    on<LoadReportsEfficiencyEvent>(_onLoadReportsEfficiency);
    on<SearchReportsEfficiencyEvent>(_onSearchReportsEfficiency);
    on<ChangeReportsEfficiencyScopeEvent>(_onChangeReportsEfficiencyScope);
    on<LoadTaskBySectorEvent>(_onLoadTaskBySector);
    on<LoadTaskByMonthEvent>(_onLoadTaskByMonth);
  }

  Future<void> _onLoadFormularyByMonth(
    LoadFormularyByMonthEvent event,
    Emitter<VisualizeReportsState> emit,
  ) async {
    final currentState = state;
    if (currentState is VisualizeReportsLoadedState) {
      emit(currentState.copyWith());
    } else {
      emit(VisualizeReportsLoadingState());
    }

    try {
      final params = GetFormularyByMonthParams(
        dtStart: event.dtStart,
        untilDate: event.untilDate,
        dayCurrent: "",
        typeTask: ['ROTINA'],
        status: [],
      );

      final result = await _getFormularyByMonthUseCase(params);

      result.fold(
        (failure) {
          final currentState = state;
          if (currentState is VisualizeReportsLoadedState) {
            emit(currentState.copyWith(
              formularyData: const FormularyByMonthResponseEntity(
                formularyByMonthDto: [],
                totalConcluidos: 0,
                totalNaoConcluidos: 0,
                totalGeral: 0,
              ),
            ));
          } else {
            emit(VisualizeReportsErrorState(
              message: failure.toString(),
            ));
          }
        },
        (response) {
          final currentState = state;
          if (currentState is VisualizeReportsLoadedState) {
            emit(currentState.copyWith(
              formularyData: response,
            ));
          } else {
            emit(VisualizeReportsLoadedState(
              formularyData: response,
            ));
          }

          add(LoadReportsEfficiencyEvent(
            dtStart: event.dtStart,
            untilDate: event.untilDate,
          ));
        },
      );
    } catch (e) {
      final currentState = state;
      if (currentState is VisualizeReportsLoadedState) {
        emit(currentState.copyWith(
          formularyData: const FormularyByMonthResponseEntity(
            formularyByMonthDto: [],
            totalConcluidos: 0,
            totalNaoConcluidos: 0,
            totalGeral: 0,
          ),
        ));
      } else {
        emit(VisualizeReportsErrorState(
          message: 'Erro inesperado: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onLoadFormularyByMonthWithFilters(
    LoadFormularyByMonthWithFiltersEvent event,
    Emitter<VisualizeReportsState> emit,
  ) async {
    final currentState = state;
    if (currentState is VisualizeReportsLoadedState) {
      emit(currentState.copyWith());
    } else {
      emit(VisualizeReportsLoadingState());
    }

    try {
      final params = GetFormularyByMonthParams(
        dtStart: event.dtStart,
        untilDate: event.untilDate,
        dayCurrent: "",
        responsibleIds: event.responsibleIds,
        assetIds: event.assetIds,
        localIds: event.localIds,
        typeTask: event.typeTask,
        status: event.status,
      );

      final result = await _getFormularyByMonthUseCase(params);

      result.fold(
        (failure) {
          final currentState = state;
          if (currentState is VisualizeReportsLoadedState) {
            emit(currentState.copyWith(
              formularyData: const FormularyByMonthResponseEntity(
                formularyByMonthDto: [],
                totalConcluidos: 0,
                totalNaoConcluidos: 0,
                totalGeral: 0,
              ),
            ));
          } else {
            emit(VisualizeReportsErrorState(
              message: failure.toString(),
            ));
          }
        },
        (response) {
          final currentState = state;
          if (currentState is VisualizeReportsLoadedState) {
            emit(currentState.copyWith(
              formularyData: response,
            ));
          } else {
            emit(VisualizeReportsLoadedState(
              formularyData: response,
            ));
          }

          add(LoadReportsEfficiencyEvent(
            dtStart: event.dtStart,
            untilDate: event.untilDate,
            responsibleIds: event.responsibleIds,
            assetIds: event.assetIds,
            localIds: event.localIds,
            typeTask: event.typeTask,
            status: event.status,
          ));
        },
      );
    } catch (e) {
      emit(VisualizeReportsErrorState(
        message: 'Erro inesperado: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadReportsEfficiency(
    LoadReportsEfficiencyEvent event,
    Emitter<VisualizeReportsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! VisualizeReportsLoadedState) return;

    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      final currentDate = dateFormat.format(DateTime.now());
      final typeTask =
          event.typeTask?.isNotEmpty == true ? event.typeTask! : ['ROTINA'];
      final status =
          event.status?.isNotEmpty == true ? event.status! : <String>[];
      final responsibleIds = event.responsibleIds ?? [];
      final resultResponsibles =
          await _repository.getMaintenanceTasksEfficiency(
        dtStart: event.dtStart,
        untilDate: event.untilDate,
        typeTask: typeTask,
        dayCurrent: currentDate,
        procedureGroupLabels: [],
        procedureGroupIds: [],
        responsibleIds: responsibleIds,
        displayBy: 'RESPONSAVEL',
        status: status,
      );

      final resultGroups = await _repository.getMaintenanceTasksEfficiency(
        dtStart: event.dtStart,
        untilDate: event.untilDate,
        typeTask: typeTask,
        dayCurrent: currentDate,
        procedureGroupLabels: [],
        procedureGroupIds: [],
        responsibleIds: responsibleIds,
        displayBy: 'GRUPO',
        status: status,
      );

      List<last_week_state.EfficiencyItem> responsibles = [];
      List<last_week_state.EfficiencyItem> groups = [];
      TaskSummaryEntity? taskSummary;

      resultResponsibles.fold(
        (failure) {},
        (response) {
          responsibles = response.efficiencyResponse
              .map((item) => item.toBlocItem(avatarColor: '#2F80ED'))
              .toList();
          taskSummary = response.taskSummary;
        },
      );

      resultGroups.fold(
        (failure) {},
        (response) {
          groups = response.efficiencyResponse
              .map((item) => item.toBlocItem(avatarColor: '#FF6B6B'))
              .toList();
        },
      );

      emit(currentState.copyWith(
        responsibles: responsibles,
        groups: groups,
        taskSummary: taskSummary,
      ));
    } catch (e) {}
  }

  void _onSearchReportsEfficiency(
    SearchReportsEfficiencyEvent event,
    Emitter<VisualizeReportsState> emit,
  ) {
    final currentState = state;
    if (currentState is VisualizeReportsLoadedState) {
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  void _onChangeReportsEfficiencyScope(
    ChangeReportsEfficiencyScopeEvent event,
    Emitter<VisualizeReportsState> emit,
  ) {
    final currentState = state;
    if (currentState is VisualizeReportsLoadedState) {
      emit(currentState.copyWith(currentScope: event.scope));
    }
  }

  Future<void> _onResetReports(
    ResetReportsEvent event,
    Emitter<VisualizeReportsState> emit,
  ) async {
    emit(VisualizeReportsInitialState());
  }

  void searchEfficiency(String query) {
    add(SearchReportsEfficiencyEvent(query));
  }

  void changeScope(EfficiencyScope scope) {
    add(ChangeReportsEfficiencyScopeEvent(scope));
  }

  @override
  void loadTaskBySector({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) {
    add(LoadTaskBySectorEvent(
      dtStart: dtStart,
      untilDate: untilDate,
      responsibleIds: responsibleIds,
      assetIds: assetIds,
      localIds: localIds,
      typeTask: typeTask,
      status: status,
    ));
  }

  @override
  void loadTaskByMonth({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) {
    add(LoadTaskByMonthEvent(
      dtStart: dtStart,
      untilDate: untilDate,
      responsibleIds: responsibleIds,
      assetIds: assetIds,
      localIds: localIds,
      typeTask: typeTask,
      status: status,
    ));
  }

  Future<void> _onLoadTaskBySector(
    LoadTaskBySectorEvent event,
    Emitter<VisualizeReportsState> emit,
  ) async {
    final currentState = state;

    if (currentState is! VisualizeReportsLoadedState) {
      emit(VisualizeReportsLoadedState(
        formularyData: const FormularyByMonthResponseEntity(
          formularyByMonthDto: [],
          totalConcluidos: 0,
          totalNaoConcluidos: 0,
          totalGeral: 0,
        ),
        isTaskBySectorLoading: true,
        taskBySectorError: null,
      ));
    } else {
      final shouldShowLoading = (currentState.taskBySectorData == null ||
              currentState.taskBySectorData!.isEmpty) ||
          currentState.taskBySectorError != null;

      if (shouldShowLoading) {
        emit(currentState.copyWith(
          isTaskBySectorLoading: true,
          taskBySectorError: null,
        ));
      } else {}
    }

    try {
      final result = await _getTaskBySectorUseCase.execute(
        dtStart: event.dtStart,
        untilDate: event.untilDate,
        dayCurrent: "",
        responsibleIds: event.responsibleIds ?? [],
        assetIds: event.assetIds ?? [],
        localIds: event.localIds ?? [],
        typeTask: event.typeTask ?? ["ORDEM_SERVICO"],
        status: event.status ?? [],
        localGroupIds: [],
        procedureIds: [],
        assetGroupIds: [],
        sectorIds: [],
      );

      final updatedState = state;
      if (updatedState is VisualizeReportsLoadedState) {
        result.fold(
          (failure) {
            emit(updatedState.copyWith(
              isTaskBySectorLoading: false,
              taskBySectorError: failure.toString(),
            ));
          },
          (taskBySectorResponse) {
            emit(updatedState.copyWith(
              isTaskBySectorLoading: false,
              taskBySectorData: taskBySectorResponse.data,
              taskBySectorError: null,
            ));
          },
        );
      }
    } catch (e) {
      final updatedState = state;
      if (updatedState is VisualizeReportsLoadedState) {
        emit(updatedState.copyWith(
          isTaskBySectorLoading: false,
          taskBySectorError: e.toString(),
        ));
      }
    }
  }

  Future<void> _onLoadTaskByMonth(
    LoadTaskByMonthEvent event,
    Emitter<VisualizeReportsState> emit,
  ) async {
    final currentState = state;

    if (currentState is! VisualizeReportsLoadedState) {
      emit(VisualizeReportsLoadedState(
        formularyData: const FormularyByMonthResponseEntity(
          formularyByMonthDto: [],
          totalConcluidos: 0,
          totalNaoConcluidos: 0,
          totalGeral: 0,
        ),
        isTaskByMonthLoading: true,
        taskByMonthError: null,
      ));
    } else {
      final shouldShowLoading = currentState.taskByMonthData == null ||
          currentState.taskByMonthError != null;

      if (shouldShowLoading) {
        emit(currentState.copyWith(
          isTaskByMonthLoading: true,
          taskByMonthError: null,
        ));
      } else {}
    }

    try {
      final result = await _getTaskByMonthUseCase.execute(
        dtStart: event.dtStart,
        untilDate: event.untilDate,
        responsibleIds: event.responsibleIds ?? [],
        assetIds: event.assetIds ?? [],
        localIds: event.localIds ?? [],
        typeTask: event.typeTask ?? ["ORDEM_SERVICO"],
        status: event.status ?? [],
      );

      final updatedState = state;
      if (updatedState is VisualizeReportsLoadedState) {
        result.fold(
          (failure) {
            emit(updatedState.copyWith(
              isTaskByMonthLoading: false,
              taskByMonthError: failure.toString(),
            ));
          },
          (taskByMonthResponse) {
            emit(updatedState.copyWith(
              isTaskByMonthLoading: false,
              taskByMonthData: taskByMonthResponse,
              taskByMonthError: null,
            ));
          },
        );
      }
    } catch (e) {
      final updatedState = state;
      if (updatedState is VisualizeReportsLoadedState) {
        emit(updatedState.copyWith(
          isTaskByMonthLoading: false,
          taskByMonthError: e.toString(),
        ));
      }
    }
  }

  Future<FilterOptionsEntity?> loadFilterOptions() async {
    try {
      final result = await _repository.getMaintenanceTasksFilterOptions();
      return result.fold(
        (failure) => null,
        (options) => options,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  void loadFormularyWithFilters({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) {
    add(LoadFormularyByMonthWithFiltersEvent(
      dtStart: dtStart,
      untilDate: untilDate,
      responsibleIds: responsibleIds ?? [],
      assetIds: assetIds ?? [],
      localIds: localIds ?? [],
      typeTask: typeTask ?? [],
      status: status ?? [],
    ));
  }
}
