import 'package:essentials/essentials.dart';
import '../../../domain/repository/maintenance_management_repository.dart';
import 'chart_state.dart';

class CategoriesChartCubit extends Cubit<ChartState> {
  final MaintenanceManagementRepository _repository;

  CategoriesChartCubit(this._repository) : super(ChartInitialState());

  void loadData({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? status,
  }) async {
    emit(ChartLoadingState());

    try {
      final dtStart =
          "${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}";
      final untilDate =
          "${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}";

      final result = await _repository.getTaskBySector(
        dtStart: dtStart,
        untilDate: untilDate,
        responsibleIds: responsibleIds ?? [],
        assetIds: assetIds ?? [],
        localIds: localIds ?? [],
        typeTask: ['ORDEM_SERVICO'],
        status: status ?? [],
      );

      result.fold(
        (failure) {
          emit(ChartErrorState(
              "Erro ao carregar dados de categorias: ${failure.toString()}"));
        },
        (response) {
          if (response.data.isEmpty) {
            emit(ChartEmptyState(
                "Nenhum dado de categoria encontrado para o período selecionado"));
          } else {
            emit(ChartLoadedState(response));
          }
        },
      );
    } catch (e) {
      emit(ChartErrorState("Erro inesperado: ${e.toString()}"));
    }
  }

  void reset() {
    emit(ChartInitialState());
  }
}
