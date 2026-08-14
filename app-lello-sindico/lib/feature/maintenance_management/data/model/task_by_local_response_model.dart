import 'package:json_annotation/json_annotation.dart';
import 'task_by_local_data_model.dart';

part 'task_by_local_response_model.g.dart';

@JsonSerializable()
class TaskByLocalResponseModel {
  @JsonKey(name: 'data')
  final List<TaskByLocalDataModel> data;

  const TaskByLocalResponseModel({
    required this.data,
  });

  factory TaskByLocalResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByLocalResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByLocalResponseModelToJson(this);
}
