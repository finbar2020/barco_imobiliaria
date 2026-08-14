import 'package:essentials/functional/try.dart';
import '../entity/procedure_options_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetProcedureOptionsUseCase {
  final MaintenanceManagementRepository repository;

  GetProcedureOptionsUseCase(this.repository);

  Future<Try<ProcedureOptionsEntity>> call(String typeTask) {
    return repository.getProcedureOptions(typeTask);
  }
}
