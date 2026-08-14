import 'package:json_annotation/json_annotation.dart';

part 'task_by_local_data_model.g.dart';

@JsonSerializable()
class TaskByLocalDataModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'done')
  final int done;

  @JsonKey(name: 'draft')
  final int draft;

  @JsonKey(name: 'not_started')
  final int notStarted;

  @JsonKey(name: 'total')
  final int total;

  const TaskByLocalDataModel({
    required this.id,
    required this.name,
    required this.done,
    required this.draft,
    required this.notStarted,
    required this.total,
  });

  factory TaskByLocalDataModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByLocalDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByLocalDataModelToJson(this);
}
