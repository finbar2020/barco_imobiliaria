import 'package:essentials/essentials.dart';
import '../../../enums/efficiency_scope_enum.dart';
import 'maintenance_management_last_week_event.dart';
import 'maintenance_management_last_week_state.dart';

abstract class MaintenanceManagementLastWeekBloc extends Bloc<MaintenanceManagementLastWeekEvent, MaintenanceManagementLastWeekState> {
  MaintenanceManagementLastWeekBloc() : super(MaintenanceManagementLastWeekInitialState());

  void fetchEfficiencyData();
  void searchEfficiency(String query);
  void changeScope(EfficiencyScope scope);
}
