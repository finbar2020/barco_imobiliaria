import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/quick_fix/data/data_source/remote/employee_report_remote_data_source.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:shared_features/feature/gdp/quick_fix/domain/repository/employee_report_repository.dart';

class EmployeeReportRepositoryImpl extends EmployeeReportRepository {
  final EmployeeReportRemoteDataSource remoteDataSource;

  EmployeeReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<EmployeeReport>> get(String condominiumId, String employeeId,
      EmployeeReportType reportType) async {
    try {
      final result =
          await remoteDataSource.get(condominiumId, employeeId, reportType);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
