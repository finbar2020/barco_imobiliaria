import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/data/data_source/local/income_local_data_source.dart';
import 'package:lello/feature/income/data/data_source/remote/income_remote_data_source.dart';
import 'package:lello/feature/income/data/model/income_model.dart';
import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/repository/income_repository.dart';

class IncomeRepositoryImpl extends IncomeRepository {
  final IncomeRemoteDataSource remoteDataSource;
  final IncomeLocalDataSource localDataSource;

  IncomeRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Try<Income?>> select(
      DataOrigin origin, String condominiumId, DateTime period) async {
    try {
      final future = origin == DataOrigin.local
          ? localDataSource.select(condominiumId, period)
          : remoteDataSource.select(condominiumId, period);
      final result = await future;
      if (origin == DataOrigin.remote) {
        await _saveLocal(condominiumId, period, result);
      }
      final income = result?.toEntity();
      income?.forecast!.sort((a, b) => a.period!.compareTo(b.period!));
      return Success(income);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Future<void> _saveLocal(
      String condominiumId, DateTime period, IncomeModel? models) async {
    try {
      await localDataSource.save(condominiumId, period, models!);
    } catch (ex) {}
  }
}
