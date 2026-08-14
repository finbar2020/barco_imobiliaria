import 'package:essentials/functional/try.dart';
import '../entity/filter_options_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetMaintenanceTasksFilterOptionsUseCase {
  final MaintenanceManagementRepository repository;

  GetMaintenanceTasksFilterOptionsUseCase(this.repository);

  Future<Try<FilterOptionsEntity>> call() async {
    return await repository.getMaintenanceTasksFilterOptions();
  }
}
