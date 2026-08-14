import 'package:essentials/functional/try.dart';
import '../entity/task_by_asset_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class GetTaskByAssetUseCase {
  Future<Try<TaskByAssetResponseEntity>> execute({
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

class GetTaskByAssetUseCaseImpl implements GetTaskByAssetUseCase {
  final MaintenanceManagementRepository repository;

  GetTaskByAssetUseCaseImpl(this.repository);

  @override
  Future<Try<TaskByAssetResponseEntity>> execute({
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
    return await repository.getTaskByAsset(
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
