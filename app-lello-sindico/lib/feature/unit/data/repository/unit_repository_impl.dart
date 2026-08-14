import 'package:essentials/essentials.dart';
import 'package:lello/feature/unit/data/data_source/local/unit_local_data_source.dart';
import 'package:lello/feature/unit/data/data_source/remote/unit_remote_data_source.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';
import 'package:lello/feature/unit/domain/repository/unit_repository.dart';

class UnitRepositoryImpl extends UnitRepository {
  final UnitLocalDataSource localDataSource;
  final UnitRemoteDataSource remoteDataSource;

  UnitRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Try<List<Unit>>> list(
    DataOrigin origin,
    String condominiumId, {
    String? lastUnitId,
    String? query,
    bool? loadAll,
    String? blockName,
    String? unitName,
    bool? hasAppInstalled,
    bool? showOnlyUnitsWithBiometrics,
    String? vehicleIdentification,
    String? vehicleTypeSelected,
    bool? filterOnlyWithTenant,
  }) async {
    try {
      final future = origin == DataOrigin.local
          ? localDataSource.list(condominiumId)
          : remoteDataSource.list(
              condominiumId,
              lastUnitId: lastUnitId,
              query: query,
              loadAll: loadAll,
              blockName: blockName,
              unitName: unitName,
              hasAppInstalled: hasAppInstalled,
              showOnlyUnitsWithBiometrics: showOnlyUnitsWithBiometrics,
              vehicleIdentification: vehicleIdentification,
              vehicleTypeSelected: vehicleTypeSelected,
              filterOnlyWithTenant: filterOnlyWithTenant,
            );
      final result = await future;
      if (origin == DataOrigin.remote && query?.isEmpty != false) {
        await _saveLocal(condominiumId, result);
      }
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  Future<void> _saveLocal(String condominiumId, List<UnitModel> models) async {
    try {
      await localDataSource.insert(condominiumId, models);
    } catch (_) {}
  }

  @override
  Future<Try<List<UnitSimple>>> listSimple(String condominiumId) async {
    try {
      final result = await remoteDataSource.listSimple(
        condominiumId,
      );

      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
