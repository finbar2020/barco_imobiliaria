import 'package:essentials/essentials.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles_type_enum.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles.dart';

class SaveVehicleImpl extends SaveVehicle {
  final VehicleRepository repository;

  SaveVehicleImpl({required this.repository});

  @override
  Future<Try<List<Vehicle>>> call(SaveVehicleParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.post(params.vehicle);
  }

  /// Decisao: `validate` existia mas nunca era chamado por `call` (codigo
  /// morto) e devolvia `SaveVehicleValidationFaliure` justamente para o
  /// veiculo valido. Foi ligado ao `call` com as mesmas regras de
  /// `UpDateVehicleImpl._validate` (tipo e cor obrigatorios; placa
  /// obrigatoria exceto para bicicleta), devolvendo `null` quando valido.
  Failure? validate(SaveVehicleParam params) {
    if (params.vehicle.type == null) return InvalidParamFailure();
    if (params.vehicle.type!.toUpperCase() !=
            enumToString(VehiclesType.bicicleta)!.toUpperCase() &&
        params.vehicle.identificationNumber == null)
      return InvalidParamFailure();
    if (params.vehicle.color == null) return InvalidParamFailure();
    return null;
  }
}
