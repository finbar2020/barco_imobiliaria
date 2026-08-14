import 'package:essentials/functional/try.dart';

import '../entity/assets_lookup_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetAssetsLookupUseCase {
  final MaintenanceManagementRepository repository;

  GetAssetsLookupUseCase(this.repository);

  Future<Try<AssetsLookupEntity>> call(String procedureIds) async {
    return await repository.getAssetsLookup(procedureIds);
  }
}
