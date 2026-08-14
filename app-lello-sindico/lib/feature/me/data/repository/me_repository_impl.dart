import 'package:essentials/essentials.dart';
import 'package:lello/feature/me/data/data_source/local/me_local_data_source.dart';
import 'package:lello/feature/me/data/data_source/remote/me_remote_data_source.dart';
import 'package:lello/feature/me/data/model/me_model.dart';
import 'package:lello/feature/me/data/model/me_password_model.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';

class MeRepositoryImpl extends MeRepository {
  final MeLocalDataSource localDataSource;
  final MeRemoteDataSource remoteDataSource;
  final baseUrl;

  MeRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.baseUrl});

  @override
  Future<Try<Me?>> save(Me? me, String code) async {
    try {
      final model = MeModel.fromEntity(me!);
      final newMe = await remoteDataSource.patch(model, code);
      final result = await localDataSource.save(newMe);
      return Success(result?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Me?>> updatePassword(
      String cpf, String originPassword, String password) async {
    try {
      final model = MePasswordModel.init(cpf, originPassword, password);
      await remoteDataSource.updatePassword(model);
      return Success(null);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Me>> select() async {
    final Trace myTrace = FirebasePerformance.instance.newTrace("me_get");
    try {
      myTrace.start();
      final me = await remoteDataSource.get();
      final entity = me.toEntity();
      await localDataSource.save(MeModel.fromEntity(entity));

      return Success(entity.copyWith(
          pictureLink: "$baseUrl/me/pictures/file/${entity.pictureHash}"));
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    } finally {
      myTrace.stop();
    }
  }

  @override
  Future<Try<Me?>> selectFromCache() async {
    try {
      final me = await localDataSource.select();
      return Success(me?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Nothing>> clear() async {
    try {
      await localDataSource.save(null);
      return Success(Nothing());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
