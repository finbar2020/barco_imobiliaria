import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';

abstract class GetVehicle extends UseCase<List<Vehicle>, GetVehicleParam> {}

class GetVehicleParam {
  final String unityId;
  GetVehicleParam({required this.unityId});
}
