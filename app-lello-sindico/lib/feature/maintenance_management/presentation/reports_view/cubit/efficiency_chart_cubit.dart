import 'package:essentials/essentials.dart';
import 'chart_state.dart';
import '../../../domain/use_cases/get_formulary_by_month_use_case.dart';
import '../bloc/visualize_reports_bloc.dart';

class EfficiencyChartCubit extends Cubit<ChartState> {
  final GetFormularyByMonthUseCase _getFormularyByMonthUseCase;
  VisualizeReportsBloc? _reportsBloc;

  EfficiencyChartCubit(this._getFormularyByMonthUseCase)
      : super(ChartInitialState());

  void setReportsBloc(VisualizeReportsBloc reportsBloc) {
    _reportsBloc = reportsBloc;
  }

  void loadData({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) async {
    emit(ChartLoadingState());

    try {
      final dtStart =
          "${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}";
      final untilDate =
          "${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}";

      // Também dispara o carregamento no VisualizeReportsBloc para os dados de eficiência
      _reportsBloc?.loadFormularyWithFilters(
        dtStart: dtStart,
        untilDate: untilDate,
        responsibleIds: responsibleIds ?? [],
        assetIds: assetIds ?? [],
        localIds: localIds ?? [],
        typeTask: typeTask ?? ['ROTINA'],
        status: status ?? [],
      );

      final params = GetFormularyByMonthParams(
        dtStart: dtStart,
        untilDate: untilDate,
        dayCurrent: "",
        responsibleIds: responsibleIds ?? [],
        assetIds: assetIds ?? [],
        localIds: localIds ?? [],
        typeTask: typeTask ?? ['ROTINA'],
        status: status ?? [],
      );

      final result = await _getFormularyByMonthUseCase(params);

      result.fold(
        (failure) {
          emit(ChartErrorState(
              "Erro ao carregar dados de eficiência: ${failure.toString()}"));
        },
        (response) {
          if (response.formularyByMonthDto.isEmpty) {
            emit(ChartEmptyState(
                "Nenhum dado de eficiência encontrado para o período selecionado"));
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
