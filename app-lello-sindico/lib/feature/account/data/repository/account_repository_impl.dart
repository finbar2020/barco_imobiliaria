import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/data/data_source/local/account_local_data_source.dart';
import 'package:lello/feature/account/data/data_source/remote/account_remote_data_source.dart';
import 'package:lello/feature/account/data/model/account_model.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/account/domain/repository/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountLocalDataSource localDataSource;
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Try<List<Account>>> list(
      DataOrigin origin, String condominiumId) async {
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

  Future<void> _saveLocal(
      String condominiumId, List<AccountModel> models) async {
    try {
      await localDataSource.save(condominiumId, models);
    } catch (_) {}
  }
}
