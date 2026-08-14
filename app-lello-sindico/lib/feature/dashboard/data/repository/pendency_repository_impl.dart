import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/data/data_source/local/pendency_local_data_source.dart';
import 'package:lello/feature/dashboard/data/data_source/remote/pendency_remote_data_source.dart';
import 'package:lello/feature/dashboard/data/model/pendency_model.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/domain/repository/pendency_repository.dart';

class PendencyRepositoryImpl extends PendencyRepository {
  final PendencyLocalDataSource localDataSource;
  final PendencyRemoteDataSource remoteDataSource;

  PendencyRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Try<List<Pendency>>> save(
      String condominiumId, List<Pendency> pendencies) async {
    try {
      final List<PendencyModel> models =
          pendencies.map((e) => PendencyModel.fromEntity(e)!).toList();
      final result = await localDataSource.save(condominiumId, models);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<Pendency>>> select(String condominiumId,
      {String? lastPendencyId}) async {
    try {
      final result = await remoteDataSource.list(condominiumId, lastPendencyId);
      final entities = result.map((e) => e.toEntity()).toList();
      if (result.isNotEmpty && lastPendencyId == null) {
        await save(condominiumId, entities);
      }
      return Success(entities);
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<Pendency>>> selectPagination(String condominiumId,
      {int? currentSize}) async {
    try {
      final result =
          await remoteDataSource.listPagination(condominiumId, currentSize);
      final entities = result.map((e) => e.toEntity()).toList();
      if (result.isNotEmpty && currentSize == null) {
        await save(condominiumId, entities);
      }
      return Success(entities);
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<Pendency>>> updateNotification(
      String condominiumId, String pendencyId) async {
    try {
      final result = await remoteDataSource.update(condominiumId, pendencyId);
      final entities = result.map((e) => e.toEntity()).toList();
      if (result.isNotEmpty) {
        await save(condominiumId, entities);
      }
      return Success(entities);
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<Pendency>>> selectCache(String condominiumId) async {
    try {
      final result = await localDataSource.list(condominiumId);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Nothing>> clear() async {
    try {
      await localDataSource.clear(null);
      return Success(Nothing());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
