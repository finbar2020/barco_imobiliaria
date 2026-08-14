import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';
import 'package:morar/feature/vehicles/domain/use_cases/delete_vehicles/delete_vehicle.dart';

class DeleteVehiceleImpl extends DeleteVehicle {
  final VehicleRepository repository;
  DeleteVehiceleImpl({required this.repository});

  @override
  Future<Try<String>> call(DeleteVehicleParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return await repository.delete(params.id);
  }

  Failure? _validate(DeleteVehicleParam params) {
    if (params.id.isEmpty) return InvalidParamFailure();
    return null;
  }
}
