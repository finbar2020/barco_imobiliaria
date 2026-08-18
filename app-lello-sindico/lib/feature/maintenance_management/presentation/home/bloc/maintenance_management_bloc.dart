import 'package:essentials/essentials.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_state.dart';

import '../../../domain/entity/filter_options_entity.dart';

abstract class MaintenanceManagementBloc
    extends Bloc<MaintenanceManagementEvent, MaintenanceManagementState> {
  MaintenanceManagementBloc(super.initialState);

  Future<void> fetchCondominiumInfo();

  Future<void> fetchFilterOptions();

  FilterOptionsEntity? get filterOptions;

  Future<void> applyFilters(FilterOptionsEntity? filterOptions);

  Future<void> fetchTasksWithFilters(
    String dtstart,
    String untilDate,
    FilterOptionsEntity? appliedFilters,
  );
}
