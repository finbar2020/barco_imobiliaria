import 'package:json_annotation/json_annotation.dart';
import 'task_by_sector_data_model.dart';

part 'task_by_sector_response_model.g.dart';

@JsonSerializable()
class TaskBySectorResponseModel {
  @JsonKey(name: 'data')
  final List<TaskBySectorDataModel> data;

  const TaskBySectorResponseModel({
    required this.data,
  });

  factory TaskBySectorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TaskBySectorResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskBySectorResponseModelToJson(this);
}
