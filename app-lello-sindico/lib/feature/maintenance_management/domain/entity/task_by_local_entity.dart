import 'package:equatable/equatable.dart';

class TaskByLocalDataEntity extends Equatable {
  final String id;
  final String name;
  final int done;
  final int draft;
  final int notStarted;
  final int total;

  const TaskByLocalDataEntity({
    required this.id,
    required this.name,
    required this.done,
    required this.draft,
    required this.notStarted,
    required this.total,
  });

  @override
  List<Object?> get props => [id, name, done, draft, notStarted, total];
}

class TaskByLocalResponseEntity extends Equatable {
  final List<TaskByLocalDataEntity> data;

  const TaskByLocalResponseEntity({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}
