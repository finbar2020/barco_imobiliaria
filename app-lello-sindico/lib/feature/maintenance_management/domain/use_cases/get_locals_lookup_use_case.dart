import 'package:essentials/functional/try.dart';
import '../entity/locals_lookup_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetLocalsLookupUseCase {
  final MaintenanceManagementRepository repository;

  GetLocalsLookupUseCase(this.repository);

  Future<Try<LocalsLookupEntity>> call(String procedureIds) async {
    return await repository.getLocalsLookup(procedureIds);
  }
}
