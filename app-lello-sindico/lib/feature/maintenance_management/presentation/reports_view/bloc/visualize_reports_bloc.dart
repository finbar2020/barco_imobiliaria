import 'package:flutter_bloc/flutter_bloc.dart';
import '../../enums/efficiency_scope_enum.dart';
import '../../../domain/entity/filter_options_entity.dart';
import 'visualize_reports_event.dart';
import 'visualize_reports_state.dart';

abstract class VisualizeReportsBloc
    extends Bloc<VisualizeReportsEvent, VisualizeReportsState> {
  VisualizeReportsBloc() : super(VisualizeReportsInitialState());

  void searchEfficiency(String query);
  void changeScope(EfficiencyScope scope);
  void loadFormularyWithFilters({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  });

  void loadTaskBySector({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  });

  void loadTaskByMonth({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  });

  Future<FilterOptionsEntity?> loadFilterOptions();
}
