import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/data/data_source/local/resident_local_data_source.dart';
import 'package:lello/feature/resident/data/data_source/remote/resident_remote_data_source.dart';
import 'package:lello/feature/resident/data/model/resident_model.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';

class ResidentRepositoryImpl extends ResidentRepository {
  final ResidentLocalDataSource localDataSource;
  final ResidentRemoteDataSource remoteDataSource;

  ResidentRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Try<List<Resident>>> list(DataOrigin origin, String condominiumId,
      {String? lastResidentId, String? query, bool loadAll = false}) async {
    try {
      final future = origin == DataOrigin.local
          ? localDataSource.list(condominiumId)
          : remoteDataSource.list(condominiumId,
              lastResidentId: lastResidentId, query: query, loadAll: loadAll);
      final result = await future;
      if (origin == DataOrigin.remote && query?.isEmpty != false) {
        await _saveLocal(condominiumId, result);
      }
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  Future<void> _saveLocal(
      String condominiumId, List<ResidentModel> models) async {
    try {
      await localDataSource.insert(condominiumId, models);
    } catch (_) {}
  }

  @override
  Future<Try<List<Resident>>> listFromUnit(
      String condominiumId, String unitId) async {
    try {
      final result = await remoteDataSource.listFromUnit(condominiumId, unitId);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
