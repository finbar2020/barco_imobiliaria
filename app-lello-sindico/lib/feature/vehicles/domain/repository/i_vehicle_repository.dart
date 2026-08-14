import 'package:essentials/essentials.dart';

import '../entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<Try<List<Vehicle>>> list(
    String condominiumId,
    String unitId, {
    String? query,
    bool? loadAll,
  });
}
