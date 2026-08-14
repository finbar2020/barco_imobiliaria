import 'package:lello/feature/vehicles/data/model/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> list(
    String condominiumId,
    String unitId, {
    String? query,
    bool? loadAll,
  });
}
