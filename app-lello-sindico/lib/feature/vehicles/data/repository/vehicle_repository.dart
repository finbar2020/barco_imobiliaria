import 'package:essentials/essentials.dart';
import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';

import '../../domain/repository/i_vehicle_repository.dart';
import '../datasource/vehicle_datasource.dart';

class VehicleRepositoryImpl extends VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  VehicleRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<List<Vehicle>>> list(
    String condominiumId,
    String unitId, {
    String? query,
    bool? loadAll,
  }) async {
    try {
      final result = await remoteDataSource.list(
        condominiumId,
        unitId,
        query: query,
        loadAll: loadAll,
      );

      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
