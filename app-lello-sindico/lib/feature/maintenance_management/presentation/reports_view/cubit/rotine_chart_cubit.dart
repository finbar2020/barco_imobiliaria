import 'package:essentials/essentials.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_formulary_by_month_use_case.dart';
import 'chart_state.dart';

/// Cubit para gráfico de Rotina (RoutineAnalysisChart)
class RoutineChartCubit extends Cubit<ChartState> {
  final GetFormularyByMonthUseCase _getFormularyByMonthUseCase;

  RoutineChartCubit(
    this._getFormularyByMonthUseCase,
  ) : super(ChartInitialState());

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

      final result = await _getFormularyByMonthUseCase.call(
        GetFormularyByMonthParams(
          dtStart: dtStart,
          untilDate: untilDate,
          typeTask: ["ROTINA"],
          status: status ?? [],
          responsibleIds: responsibleIds ?? [],
          assetIds: assetIds ?? [],
          localIds: localIds ?? [],
        ),
      );

      result.fold(
        (failure) {
          final message = failure is KnownFailure
              ? failure.message ?? "Erro desconhecido"
              : "Erro ao carregar dados de rotina";
          emit(ChartErrorState(message));
        },
        (data) {
          if (data.formularyByMonthDto.isEmpty) {
            emit(const ChartEmptyState(
                "Nenhum dado de rotina encontrado para o período selecionado"));
          } else {
            emit(ChartLoadedState(data));
          }
        },
      );
    } catch (error) {
      emit(ChartErrorState(
          "Erro inesperado ao carregar dados de rotina: $error"));
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
