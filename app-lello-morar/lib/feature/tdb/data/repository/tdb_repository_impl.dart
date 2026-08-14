import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_remote_data_source.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';
import 'package:morar/feature/tdb/domain/repository/tdb_repository.dart';

class TDBRepositoryImpl extends TDBRepository {
  final TDBRemoteDataSource remoteDataSource;

  TDBRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<TDBInfo>> getTDBInfo(String condominiumId) async {
    try {
      final result = await remoteDataSource.getTDBInfo(condominiumId);
      TDBInfo entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
