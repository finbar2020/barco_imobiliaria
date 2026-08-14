import '../data/model/task_by_sector_response_model.dart';
import '../data/model/task_by_sector_data_model.dart';
import '../domain/entity/task_by_sector_entity.dart';

class TaskBySectorResponseModelAdapter {
  static TaskBySectorResponseEntity toEntity(TaskBySectorResponseModel model) {
    final result = TaskBySectorResponseEntity(
      data: model.data
          .map((item) => TaskBySectorDataModelAdapter.toEntity(item))
          .toList(),
    );

    return result;
  }
}

class TaskBySectorDataModelAdapter {
  static TaskBySectorDataEntity toEntity(TaskBySectorDataModel model) {
    return TaskBySectorDataEntity(
      id: model.id,
      name: model.name,
      value: model.value,
      color: model.color,
    );
  }
}
