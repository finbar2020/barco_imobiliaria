import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payroll/data/data_source/payroll/payroll_remote_data_source.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';
import 'package:shared_features/feature/gdp/payroll/domain/repository/payroll_repository.dart';

class PayrollRepositoryImpl extends PayrollRepository {
  final PayrollRemoteDataSource remoteDataSource;

  PayrollRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<Payroll>> select(String condominiumId, DateTime period) async {
    try {
      final result = await remoteDataSource.select(condominiumId, period);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<Payroll>>> list(String condominiumId) async {
    try {
      final result = await remoteDataSource.list(condominiumId);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
