import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:essentials/essentials.dart';

abstract class SaveVehicle extends UseCase<List<Vehicle>, SaveVehicleParam> {}

class SaveVehicleParam {
  final Vehicle vehicle;
  SaveVehicleParam(this.vehicle);
}
