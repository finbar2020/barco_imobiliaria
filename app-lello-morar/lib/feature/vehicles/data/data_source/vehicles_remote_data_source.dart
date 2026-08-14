import 'package:morar/feature/vehicles/data/models/vehicles_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>?> getVehiclesList(String unityId);
  Future<List<VehicleModel>?> insertVehicle(VehicleModel vehicleModel);
  Future<List<VehicleModel>?> put(VehicleModel vehicleModel, String id);
  Future<String> delete(String id);
}
