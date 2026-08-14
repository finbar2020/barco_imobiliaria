import 'package:essentials/functional/try.dart';
import '../entity/task_by_month_response_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class GetTaskByMonthUseCase {
  Future<Try<TaskByMonthResponseEntity>> execute({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  });
}

class GetTaskByMonthUseCaseImpl implements GetTaskByMonthUseCase {
  final MaintenanceManagementRepository repository;

  GetTaskByMonthUseCaseImpl(this.repository);

  @override
  Future<Try<TaskByMonthResponseEntity>> execute({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) async {
    return await repository.getTaskByMonth(
      dtStart: dtStart,
      untilDate: untilDate,
      responsibleIds: responsibleIds,
      assetIds: assetIds,
      localIds: localIds,
      typeTask: typeTask,
      status: status,
    );
  }
}