import 'task_by_month_data_point_entity.dart';

class TaskByMonthDataEntity {
  final String name;
  final List<TaskByMonthDataPointEntity> data;

  const TaskByMonthDataEntity({
    required this.name,
    required this.data,
  });
}