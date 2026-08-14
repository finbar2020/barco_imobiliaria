import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_detail_local_data_source.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_remote_data_source.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_detail_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_detail_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail.dart';

class CondominiumBalanceDetailRepositoryImpl
    extends CondominiumBalanceDetailRepository {
  final CondominiumBalanceRemoteDataSource remoteDataSource;
  final CondominiumBalanceDetailLocalDataSource localDataSource;

  CondominiumBalanceDetailRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Try<CondominiumBalanceDetail>> select(
      LoadCondominiumBalanceDetailParam params) async {
    try {
      final model = await remoteDataSource.selectDetail(
          params.condominiumId, params.filter);
      var balanceEntity = model.toEntity();
      balanceEntity.reference = params.reference;
      balanceEntity.lastUpdatedAt = DateTime.now();

      await localDataSource
          .save(CondominiumBalanceDetailModel.fromEntity(balanceEntity));
      return Success(balanceEntity);
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<CondominiumBalanceDetail?>> selectFromCache(
      LoadCondominiumBalanceDetailParam params) async {
    try {
      final condominiumBalance = await localDataSource.select(params.reference);
      return Success(condominiumBalance?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
