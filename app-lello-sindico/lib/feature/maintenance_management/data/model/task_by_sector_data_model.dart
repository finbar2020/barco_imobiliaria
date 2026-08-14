import 'package:json_annotation/json_annotation.dart';

part 'task_by_sector_data_model.g.dart';

@JsonSerializable()
class TaskBySectorDataModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'value')
  final int value;

  @JsonKey(name: 'color')
  final String color;

  const TaskBySectorDataModel({
    required this.id,
    required this.name,
    required this.value,
    required this.color,
  });

  factory TaskBySectorDataModel.fromJson(Map<String, dynamic> json) =>
      _$TaskBySectorDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskBySectorDataModelToJson(this);
}
