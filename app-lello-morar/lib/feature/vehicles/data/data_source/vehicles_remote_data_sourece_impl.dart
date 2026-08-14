import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_api.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_remote_data_source.dart';
import 'package:morar/feature/vehicles/data/models/vehicles_model.dart';

class VehicleRemoteDataSourceImpl extends VehicleRemoteDataSource {
  final VehicleApi api;

  VehicleRemoteDataSourceImpl({required this.api});

  @override
  Future<String> delete(String id) async {
    final response = await api.delete(id);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }

  @override
  Future<List<VehicleModel>?> insertVehicle(VehicleModel vehicleModel) async {
    final response = await api.post(vehicleModel);
    final vehicle =
        ApiMapper.mapList(response, (json) => VehicleModel.fromJson(json));
    return vehicle;
  }

  @override
  Future<List<VehicleModel>?> getVehiclesList(String unitId) async {
    final response = await api.getVehiclesList(unitId);
    return ApiMapper.mapList(response, (json) => VehicleModel.fromJson(json));
  }

  @override
  Future<List<VehicleModel>?> put(VehicleModel vehicleModel, String id) async {
    final response = await api.put(vehicleModel);
    final vehicle =
        ApiMapper.mapList(response, (json) => VehicleModel.fromJson(json));
    return vehicle;
  }
}
