import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles_failure.dart';

class SaveVehicleImpl extends SaveVehicle {
  final VehicleRepository repository;

  SaveVehicleImpl({required this.repository});

  @override
  Future<Try<List<Vehicle>>> call(SaveVehicleParam params) async {
    var result = await repository.post(params.vehicle);
    return result;
  }

  Failure validate(SaveVehicleParam params) {
    if (params.vehicle.type == null) return InvalidParamFailure();
    if (params.vehicle.model == null) return InvalidParamFailure();
    if (params.vehicle.color == null) return InvalidParamFailure();
    if (params.vehicle.unitId == null) return InvalidParamFailure();
    if (params.vehicle.identificationNumber == null)
      return InvalidParamFailure();
    return SaveVehicleValidationFaliure();
  }
}
