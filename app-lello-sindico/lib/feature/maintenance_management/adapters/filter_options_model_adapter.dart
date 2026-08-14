import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

import '../data/model/filter_options_model.dart';
import '../domain/entity/filter_options_entity.dart';

class FilterOptionsModelAdapter {
  static FilterOptionsEntity fromModel(FilterOptionsModel model) {
    return FilterOptionsEntity(
      locals: model.locals
          .map((local) => FilterLocalEntity(
                id: local.id,
                name: local.name,
              ))
          .toList(),
      assets: model.assets
          .map((asset) => FilterAssetEntity(
                id: asset.id,
                name: asset.name,
              ))
          .toList(),
      responsibles: model.responsibles
          .map((responsible) => FilterResponsibleEntity(
                id: responsible.id,
                name: responsible.name,
              ))
          .toList(),
      employeeGroup: model.employeeGroup
          .map((group) => FilterEmployeeGroupEntity(
                id: group.id,
                name: group.name,
              ))
          .toList(),
      taskType: TaskType.values,
      taskStatus: TaskStatusType.values,
    );
  }
}
