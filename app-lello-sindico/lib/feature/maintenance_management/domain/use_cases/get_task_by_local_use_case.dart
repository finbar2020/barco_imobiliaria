import 'package:essentials/functional/try.dart';
import '../entity/task_by_local_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class GetTaskByLocalUseCase {
  Future<Try<TaskByLocalResponseEntity>> execute({
    required String dtStart,
    required String untilDate,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
    List<String>? localGroupIds,
    List<String>? procedureIds,
    List<String>? assetGroupIds,
    List<String>? sectorIds,
  });
}

class GetTaskByLocalUseCaseImpl implements GetTaskByLocalUseCase {
  final MaintenanceManagementRepository repository;

  GetTaskByLocalUseCaseImpl(this.repository);

  @override
  Future<Try<TaskByLocalResponseEntity>> execute({
    required String dtStart,
    required String untilDate,
    String? dayCurrent,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
    List<String>? localGroupIds,
    List<String>? procedureIds,
    List<String>? assetGroupIds,
    List<String>? sectorIds,
  }) async {
    return await repository.getTaskByLocal(
      dtStart: dtStart,
      untilDate: untilDate,
      dayCurrent: dayCurrent,
      responsibleIds: responsibleIds,
      assetIds: assetIds,
      localIds: localIds,
      typeTask: typeTask,
      status: status,
      localGroupIds: localGroupIds,
      procedureIds: procedureIds,
      assetGroupIds: assetGroupIds,
      sectorIds: sectorIds,
    );
  }
}
