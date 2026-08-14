import 'package:essentials/essentials.dart';
import 'package:lello/core/widget/expire_cache.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_local_data_source.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_remote_data_source.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';

class CondominiumBalanceRepositoryImpl extends CondominiumBalanceRepository {
  final CondominiumBalanceRemoteDataSource remoteDataSource;
  final CondominiumBalanceLocalDataSource localDataSource;

  CondominiumBalanceRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Try<CondominiumBalance?>> select(
      CondominiumBalanceParam params) async {
    try {
      final model = await remoteDataSource.select(params.id);
      var balanceEntity = model.toEntity();
      balanceEntity.reference = params.reference;
      balanceEntity.lastUpdatedAt = DateTime.now();

      await localDataSource
          .save(CondominiumBalanceModel.fromEntity(balanceEntity));

      return Success(balanceEntity);
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<CondominiumBalance?>> selectFromCache(
      CondominiumBalanceParam params) async {
    try {
      final condominiumBalance = await localDataSource.select(params.reference);
      if (ExpireCache.condominiumBalance(condominiumBalance?.lastUpdatedAt))
        throw Exception("Expired cache");
      return Success(condominiumBalance?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
