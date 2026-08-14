import 'package:essentials/essentials.dart';
import 'chart_state.dart'; // Import dos estados base
import 'package:lello/feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_local_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_asset_entity.dart';

/// Cubit para gráfico de Ordem de Serviço (ServiceOrderAnalysisChart)
class ServiceOrderChartCubit extends Cubit<ChartState> {
  final MaintenanceManagementRepository _repository;

  ServiceOrderChartCubit(this._repository) : super(ChartInitialState());

  Future<void> loadData({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? status,
  }) async {
    emit(ChartLoadingState());

    try {
      final dtStart = "${startDate.day.toString().padLeft(2, '0')}/"
          "${startDate.month.toString().padLeft(2, '0')}/"
          "${startDate.year}";
      final untilDate = "${endDate.day.toString().padLeft(2, '0')}/"
          "${endDate.month.toString().padLeft(2, '0')}/"
          "${endDate.year}";

      final result = await _repository.getTaskByMonth(
        dtStart: dtStart,
        untilDate: untilDate,
        typeTask: ["ORDEM_SERVICO"],
        status: status ?? [],
        responsibleIds: responsibleIds ?? [],
        assetIds: assetIds ?? [],
        localIds: localIds ?? [],
      );

      result.fold(
        (failure) {
          final message = failure is KnownFailure
              ? failure.message ?? "Erro desconhecido"
              : "Erro ao carregar dados de ordem de serviço";
          emit(ChartErrorState(message));
        },
        (data) {
          if (data.formularyByMonthDto.isEmpty) {
            emit(const ChartEmptyState(
                "Nenhuma ordem de serviço encontrada para o período selecionado"));
          } else {
            emit(ChartLoadedState(data));
          }
        },
      );
    } catch (error) {
      emit(ChartErrorState(
          "Erro inesperado ao carregar dados de ordem de serviço: $error"));
    }
  }

  void refresh({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? status,
  }) {
    loadData(
      startDate: startDate,
      endDate: endDate,
      responsibleIds: responsibleIds,
      assetIds: assetIds,
      localIds: localIds,
      status: status,
    );
  }
}