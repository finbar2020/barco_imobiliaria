import 'package:equatable/equatable.dart';

class TaskByAssetDataEntity extends Equatable {
  final int? id;
  final String? name;
  final int? done;
  final int? draft;
  final int? notStarted;
  final int? total;

  const TaskByAssetDataEntity({
    this.id,
    this.name,
    this.done,
    this.draft,
    this.notStarted,
    this.total,
  });

  @override
  List<Object?> get props => [id, name, done, draft, notStarted, total];
}

class TaskByAssetResponseEntity extends Equatable {
  final List<TaskByAssetDataEntity>? dataTaskByAssetResponse;

  const TaskByAssetResponseEntity({
    this.dataTaskByAssetResponse,
  });

  @override
  List<Object?> get props => [dataTaskByAssetResponse];
}
