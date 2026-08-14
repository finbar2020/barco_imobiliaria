import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';
import 'package:morar/feature/vehicles/domain/use_cases/get_vehicles/get_vehicles.dart';

class GetVehicleImpl extends GetVehicle {
  final VehicleRepository repository;

  GetVehicleImpl({required this.repository});

  @override
  Future<Try<List<Vehicle>>> call(GetVehicleParam param) async {
    final error = _validate(param);
    if (error != null) return Rejection(error);
    return await repository.getVehicleList(param.unityId);
  }

  Failure? _validate(GetVehicleParam param) {
    if (param.unityId.isEmpty) return InvalidDataOriginFailure();
    return null;
  }
}
