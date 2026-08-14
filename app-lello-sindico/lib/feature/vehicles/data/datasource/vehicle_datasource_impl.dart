import 'package:essentials/essentials.dart';
import 'package:lello/feature/vehicles/data/datasource/vehicle_api.dart';
import 'package:lello/feature/vehicles/data/datasource/vehicle_datasource.dart';

import '../model/vehicle_model.dart';

class VehicleRemoteDataSourceImpl extends VehicleRemoteDataSource {
  final VehicleApi api;
  VehicleRemoteDataSourceImpl({required this.api});

  @override
  Future<List<VehicleModel>> list(
    String condominiumId,
    String unitId, {
    String? query,
    bool? loadAll,
  }) async {
    final response = await api.list(condominiumId, unitId,
        query: query, loadAll: loadAll == true);
    final result = ApiMapper.mapList(
      response,
      (json) => VehicleModel.fromJson(json),
    );

    return result;
  }
}
