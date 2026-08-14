import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';

abstract class VehicleRepository {
  Future<Try<List<Vehicle>>> getVehicleList(String unitId);
  Future<Try<List<Vehicle>>> post(Vehicle vehicle);
  Future<Try<List<Vehicle>>> put(Vehicle vehicle, String? vehicleId);
  Future<Try<String>> delete(String vehicleId);
}
