import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/data/data_source/local/space_local_data_source.dart';
import 'package:lello/feature/space/data/data_source/remote/space_remote_data_source.dart';
import 'package:lello/feature/space/data/model/space_model.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/repository/space_repository.dart';

class SpaceRepositoryImpl extends SpaceRepository {
  final SpaceRemoteDataSource remoteDataSource;
  final SpaceLocalDataSource localDataSource;

  SpaceRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});
  @override
  Future<Try<List<Space>>> list(String condominiumId, DataOrigin origin) async {
    try {
      final future = origin == DataOrigin.local
          ? localDataSource.list(condominiumId)
          : remoteDataSource.list(condominiumId);
      final result = await future;
      if (origin == DataOrigin.remote) {
        await _saveLocal(condominiumId, result);
      }
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  Future<void> _saveLocal(String condominiumId, List<SpaceModel> models) async {
    try {
      await localDataSource.insert(condominiumId, models);
    } catch (_) {}
  }

  @override
  Future<Try<Space>> insert(String condominiumId, Space space) async {
    try {
      final result = await remoteDataSource.insert(
          condominiumId, SpaceModel.fromEntity(space)!);
      return Success(result.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Space>> update(String condominiumId, Space space) async {
    try {
      final result = await remoteDataSource.update(
          condominiumId, SpaceModel.fromEntity(space)!);
      return Success(result.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
