import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_state.dart';

import '../../../data/exceptions/maintenance_management_api_exception.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../../domain/entity/maintenance_management_entity.dart';
import '../../../domain/use_cases/get_condominium_info_use_case.dart';
import '../../../domain/use_cases/get_maintenance_tasks_filter_options_use_case.dart';
import '../../../domain/use_cases/get_maintenance_task_events_use_case.dart';
import '../widgets/task_card/task_card_enum.dart';
import '../widgets/task_summary/task_summary_model.dart';
import 'maintenance_management_bloc.dart';

class MaintenanceManagementBlocImpl extends MaintenanceManagementBloc {
  final GetCondominiumInfoUseCase getCondominiumInfoUseCase;
  final GetMaintenanceTasksFilterOptionsUseCase getFilterOptionsUseCase;
  final GetMaintenanceTaskEventsUseCase getMaintenanceTaskEventsUseCase;

  MaintenanceManagementBlocImpl(
    this.getCondominiumInfoUseCase,
    this.getFilterOptionsUseCase,
    this.getMaintenanceTaskEventsUseCase,
  ) : super(MaintenanceManagementLoadingState()) {
    on<MaintenanceManagementLoadingEvent>((event, emit) async {
      emit(MaintenanceManagementLoadingState());
    });
    on<MaintenanceManagementLoadedEvent>((event, emit) {
      emit(
        MaintenanceManagementLoadedState(event.data),
      );
    });
    on<MaintenanceManagementTaskEventsLoadedEvent>((event, emit) {
      emit(MaintenanceManagementLoadingState());
    });
    on<MaintenanceManagementErrorEvent>((event, emit) {
      emit(
        MaintenanceManagementErrorState(event.error),
      );
    });
    on<MaintenanceManagementWarningModalEvent>((event, emit) {
      emit(
        MaintenanceManagementWarningModalState(event.entity),
      );
    });
  }

  FilterOptionsEntity? _filterOptions;
  @override
  FilterOptionsEntity? get filterOptions => _filterOptions;

  @override
  Future<void> fetchCondominiumInfo() async {
    add(MaintenanceManagementLoadingEvent());
    final result = await getCondominiumInfoUseCase();
    result.fold(
      (failure) {
        dynamic error = failure.error;
        String errorMessage = error?.toString() ?? 'Erro desconhecido';
        String? errorCode;

        // Extrai error_code se a exceção for MaintenanceManagementApiException
        if (error is MaintenanceManagementApiException) {
          errorCode = error.errorCode;
          errorMessage = error.message;
        }

        // Verificação de códigos de erro específicos que exigem modal informativo
        // ao invés da tela de erro padrão
        bool shouldShowModal = _shouldShowMaintenanceModal(errorCode);

        if (shouldShowModal) {
          // Para casos de integração, cria entidade mínima para o modal
          // Os dados reais devem ser buscados via outro endpoint se necessário
          final entityForModal = CondominiumInfoEntity(
            id: '',
            condominiumName: 'Ambiente em preparação',
            workflowUsers: '0',
            blocksCount: 0,
            floor: '0',
            unitsCount: 0,
            localsCount: 0,
            assets: 0,
            references: [],
          );

          add(MaintenanceManagementWarningModalEvent(entityForModal));
        } else {
          add(MaintenanceManagementErrorEvent(errorMessage));
        }
      },
      (data) {
        add(MaintenanceManagementLoadedEvent(data));
      },
    );
  }

  /// Verifica se o error_code indica que deve exibir modal informativo
  /// ao invés da tela de erro padrão.
  ///
  /// Códigos tratados:
  /// - CONDOMINIO_NAO_INTEGRADO: Condomínio não integrado com a plataforma
  /// - USER_PENDING_ACTIVATION: Usuário com ativação pendente
  ///
  /// A API retorna o error_code diretamente no body da resposta HTTP 400.
  bool _shouldShowMaintenanceModal(String? errorCode) {
    if (errorCode == null) return false;
    // Verifica se é um dos códigos de erro específicos
    return errorCode == 'CONDOMINIO_NAO_INTEGRADO' ||
        errorCode == 'USER_PENDING_ACTIVATION';
  }

  @override
  Future<void> fetchFilterOptions() async {
    final result = await getFilterOptionsUseCase();
    result.fold(
      (failure) {},
      (data) {
        _filterOptions = data;
      },
    );
  }

  @override
  Future<void> applyFilters(FilterOptionsEntity? filterOptions) async {
    _filterOptions = filterOptions;
  }

  @override
  Future<void> fetchTasksWithFilters(
    String dtstart,
    String untilDate,
    FilterOptionsEntity? appliedFilters,
  ) async {
    _filterOptions = appliedFilters;
    add(MaintenanceManagementLoadingEvent());

    final params = _buildTaskEventsParams(dtstart, untilDate, appliedFilters);
    final result = await getMaintenanceTaskEventsUseCase(params);

    result.fold(
      (failure) {
        add(MaintenanceManagementErrorEvent(failure.error.toString()));
      },
      (data) {
        add(MaintenanceManagementTaskEventsLoadedEvent(data));
      },
    );
  }

  GetMaintenanceTaskEventsParams _buildTaskEventsParams(
    String dtstart,
    String untilDate,
    FilterOptionsEntity? appliedFilters,
  ) {
    return GetMaintenanceTaskEventsParams(
      dtStart: DateTime.parse(dtstart.split('/').reversed.join('-')),
      untilDate: DateTime.parse(untilDate.split('/').reversed.join('-')),
      typeTask: _mapTaskTypesToStrings(appliedFilters?.taskType ?? []),
      status: _mapTaskStatusesToStrings(appliedFilters?.taskStatus ?? []),
      dayCurrent: DateTime.now(),
      procedureGroupLabels: [],
      displayBy: "GRUPO",
      assetIds: appliedFilters?.assets.map((asset) => asset.id).toList() ?? [],
      localIds: appliedFilters?.locals.map((local) => local.id).toList() ?? [],
      responsibleIds:
          appliedFilters?.responsibles.map((resp) => resp.id).toList() ?? [],
    );
  }

  List<String> _mapTaskTypesToStrings(List<TaskType> taskTypes) {
    return taskTypes.map((type) {
      switch (type) {
        case TaskType.routine:
          return "ROTINA";
        case TaskType.serviceOrder:
          return "ORDEM_SERVICO";
      }
    }).toList();
  }

  List<String> _mapTaskStatusesToStrings(List<TaskStatusType> statuses) {
    return statuses.map((status) {
      switch (status) {
        case TaskStatusType.pending:
          return "PENDENTE";
        case TaskStatusType.inProgress:
          return "EM_ANDAMENTO";
        case TaskStatusType.completed:
          return "CONCLUIDO";
      }
    }).toList();
  }
}
