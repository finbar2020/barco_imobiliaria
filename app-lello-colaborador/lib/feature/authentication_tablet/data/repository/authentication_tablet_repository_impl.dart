import 'package:colaborador/feature/authentication_tablet/data/data_source/local/authentication_tablet_local_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_remote_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/repository/authentication_tablet_repository.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class AuthenticationTabletRepositoryImpl
    extends AuthenticationTabletRepository {
  final AuthenticationTabletLocalDataSource localDataSource;
  final AuthenticationTabletRemoteDataSource remoteDataSource;

  AuthenticationTabletRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Try<CondominiumCodeInfo>> getInfoByCondoCode(String condoCode) async {
    try {
      final request = await remoteDataSource.getInfoByCondoCode(condoCode);
      await localDataSource.save(condoCode, request);
      await TabletSessionUtils.setCondoCode(condoCode);
      CondominiumCodeInfo response = request.toEntity()!;
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<CondominiumCodeInfo>> getInfoByCondoCodeFromCache() async {
    try {
      String condoCode = await TabletSessionUtils.getCondoCode() ?? "";
      final cache = await localDataSource.select(condoCode);
      if (cache == null) {
        return Rejection(KnownFailure("404", "not_found"));
      }
      CondominiumCodeInfo response = cache.toEntity()!;
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
