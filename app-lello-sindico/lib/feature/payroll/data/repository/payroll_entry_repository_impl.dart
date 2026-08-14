import 'package:essentials/essentials.dart';
import 'package:lello/feature/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_entry_repository.dart';

class PayrollEntryRepositoryImpl extends PayrollEntryRepository {
  final PayrollEntryRemoteDataSource remoteDataSource;
  PayrollEntryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<List<PayrollEntry>>> list(
      String condominiumId, DateTime period) async {
    try {
      final result = await remoteDataSource.list(condominiumId, period);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
