import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';

import 'package:essentials/essentials.dart';

import '../repository/i_vehicle_repository.dart';

class GetVehiclesUsecase
    extends UseCase<List<Vehicle>, ParamsGetVehiclesUsecase> {
  final VehicleRepository repository;

  GetVehiclesUsecase({
    required this.repository,
  });

  @override
  Future<Try<List<Vehicle>>> call(ParamsGetVehiclesUsecase params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(
      params.condominiumId,
      params.unitId,
      query: params.query,
      loadAll: params.loadAll,
    );
  }

  Failure? validate(ParamsGetVehiclesUsecase? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}

class ParamsGetVehiclesUsecase {
  final String condominiumId;
  final String unitId;
  final String? query;
  final bool? loadAll;
  ParamsGetVehiclesUsecase({
    required this.condominiumId,
    required this.unitId,
    this.query,
    this.loadAll,
  });
}
