import '../data/model/task_by_asset_response_model.dart';
import '../data/model/task_by_asset_data_model.dart';
import '../domain/entity/task_by_asset_entity.dart';

class TaskByAssetResponseModelAdapter {
  static TaskByAssetResponseEntity toEntity(TaskByAssetResponseModel model) {
    final result = TaskByAssetResponseEntity(
      dataTaskByAssetResponse: model.dataTaskByAssetResponse
          ?.map((item) => TaskByAssetDataModelAdapter.toEntity(item))
          .toList(),
    );

    return result;
  }
}

class TaskByAssetDataModelAdapter {
  static TaskByAssetDataEntity toEntity(TaskByAssetDataModel model) {
    return model.toEntity();
  }
}
