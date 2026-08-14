import '../data/model/task_by_local_response_model.dart';
import '../data/model/task_by_local_data_model.dart';
import '../domain/entity/task_by_local_entity.dart';

class TaskByLocalResponseModelAdapter {
  static TaskByLocalResponseEntity toEntity(TaskByLocalResponseModel model) {
    final result = TaskByLocalResponseEntity(
      data: model.data
          .map((item) => TaskByLocalDataModelAdapter.toEntity(item))
          .toList(),
    );

    return result;
  }
}

class TaskByLocalDataModelAdapter {
  static TaskByLocalDataEntity toEntity(TaskByLocalDataModel model) {
    return TaskByLocalDataEntity(
      id: model.id,
      name: model.name,
      done: model.done,
      draft: model.draft,
      notStarted: model.notStarted,
      total: model.total,
    );
  }
}
