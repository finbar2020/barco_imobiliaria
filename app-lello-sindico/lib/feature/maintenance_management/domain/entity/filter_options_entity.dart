import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

class FilterLocalEntity {
  final String id;
  final String name;

  FilterLocalEntity({
    required this.id,
    required this.name,
  });
}

class FilterAssetEntity {
  final String id;
  final String name;

  FilterAssetEntity({
    required this.id,
    required this.name,
  });
}

class FilterResponsibleEntity {
  final String id;
  final String name;

  FilterResponsibleEntity({
    required this.id,
    required this.name,
  });
}

class FilterEmployeeGroupEntity {
  final String id;
  final String name;

  FilterEmployeeGroupEntity({
    required this.id,
    required this.name,
  });
}

class FilterOptionsEntity {
  final List<FilterLocalEntity> locals;
  final List<FilterAssetEntity> assets;
  final List<FilterResponsibleEntity> responsibles;
  final List<FilterEmployeeGroupEntity> employeeGroup;
  final List<TaskType> taskType;
  final List<TaskStatusType> taskStatus;

  FilterOptionsEntity({
    required this.locals,
    required this.assets,
    required this.responsibles,
    required this.employeeGroup,
    required this.taskType,
    required this.taskStatus,
  });

  FilterOptionsEntity copyWith({
    List<FilterLocalEntity>? locals,
    List<FilterAssetEntity>? assets,
    List<FilterResponsibleEntity>? responsibles,
    List<FilterEmployeeGroupEntity>? employeeGroup,
    List<TaskType>? taskType,
    List<TaskStatusType>? taskStatus,
  }) {
    return FilterOptionsEntity(
      locals: locals ?? this.locals,
      assets: assets ?? this.assets,
      responsibles: responsibles ?? this.responsibles,
      employeeGroup: employeeGroup ?? this.employeeGroup,
      taskType: taskType ?? this.taskType,
      taskStatus: taskStatus ?? this.taskStatus,
    );
  }
}
