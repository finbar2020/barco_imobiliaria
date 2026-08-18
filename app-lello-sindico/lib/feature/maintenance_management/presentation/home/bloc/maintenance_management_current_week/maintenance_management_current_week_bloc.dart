import 'package:essentials/essentials.dart';

import '../../../enums/efficiency_scope_enum.dart';
import 'maintenance_management_current_week_event.dart';
import 'maintenance_management_current_week_state.dart';

abstract class MaintenanceManagementCurrentWeekBloc extends Bloc<
    MaintenanceManagementCurrentWeekEvent,
    MaintenanceManagementCurrentWeekState> {
  MaintenanceManagementCurrentWeekBloc()
      : super(MaintenanceManagementCurrentWeekInitialState());

  void changeScope(EfficiencyScope scope);
}
