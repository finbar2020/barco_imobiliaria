import 'package:essentials/essentials.dart';
import 'chart_state.dart';

class EnvironmentEquipmentChartCubit extends Cubit<ChartState> {
  EnvironmentEquipmentChartCubit() : super(ChartInitialState());

  void loadData({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? status,
    List<String>? typeTask,
  }) async {
    emit(ChartLoadingState());

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      emit(const ChartEmptyState(
          "Dados de ambiente e equipamentos em desenvolvimento"));
    } catch (e) {
      emit(ChartErrorState("Erro inesperado: ${e.toString()}"));
    }
  }

  void reset() {
    emit(ChartInitialState());
  }
}
