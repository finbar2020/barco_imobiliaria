import 'package:equatable/equatable.dart';

class TaskBySectorDataEntity extends Equatable {
  final String id;
  final String name;
  final int value;
  final String color;

  const TaskBySectorDataEntity({
    required this.id,
    required this.name,
    required this.value,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, value, color];
}

class TaskBySectorResponseEntity extends Equatable {
  final List<TaskBySectorDataEntity> data;

  const TaskBySectorResponseEntity({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}
