import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';

abstract class UpDateVehicle
    extends UseCase<List<Vehicle>, UpDateVehicleParam> {}

class UpDateVehicleParam {
  final Vehicle vehicle;
  final String? id;

  UpDateVehicleParam({required this.vehicle, this.id});
}
