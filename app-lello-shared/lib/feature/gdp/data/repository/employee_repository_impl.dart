import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/data/data_source/remote/employee_remote_data_source.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee_list_filter.dart';
import 'package:shared_features/feature/gdp/domain/repository/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  // final EmployeeLocalDataSource localDataSource;
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<List<Employee>>> list(String condominiumId, DataOrigin origin,
      {String? lastEmployeeId, EmployeeListFilter? filter}) async {
    try {
      // final future = origin == DataOrigin.local
      //     // ? localDataSource.list(condominiumId)
      //     ?? remoteDataSource.list(condominiumId,
      //         lastEmployeeId: lastEmployeeId, filter: filter);
      // final result = await future;

      final future =
          // ? localDataSource.list(condominiumId)
          remoteDataSource.list(condominiumId,
              lastEmployeeId: lastEmployeeId, filter: filter);
      final result = await future;
      // if (origin == DataOrigin.remote && filter == null) {
      //   await _saveLocal(condominiumId, result);
      // }
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  // Future<void> _saveLocal(
  //     String condominiumId, List<EmployeeModel> models) async {
  //   try {
  //     await localDataSource.save(condominiumId, models);
  //   } catch (_) {}
  // }

  @override
  Future<Try<Employee>> get(String condominiumId, String employeeId) async {
    try {
      final result = await remoteDataSource.get(condominiumId, employeeId);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
