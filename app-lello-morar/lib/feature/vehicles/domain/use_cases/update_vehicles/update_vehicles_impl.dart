import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles_type_enum.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';
import 'package:morar/feature/vehicles/domain/use_cases/update_vehicles/update_vehicles.dart';

class UpDateVehicleImpl extends UpDateVehicle {
  final VehicleRepository repository;

  UpDateVehicleImpl({required this.repository});

  @override
  Future<Try<List<Vehicle>>> call(UpDateVehicleParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.put(params.vehicle, params.id);
  }

  Failure? _validate(UpDateVehicleParam params) {
    if (params.vehicle.type == null) return InvalidParamFailure();
    if (params.vehicle.type!.toUpperCase() !=
            enumToString(VehiclesType.bicicleta)!.toUpperCase() &&
        params.vehicle.identificationNumber == null)
      return InvalidParamFailure();
    if (params.vehicle.color == null) return InvalidParamFailure();
    return null;
  }
}
