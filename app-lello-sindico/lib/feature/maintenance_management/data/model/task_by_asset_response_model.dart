import 'package:json_annotation/json_annotation.dart';
import 'task_by_asset_data_model.dart';
import '../../domain/entity/task_by_asset_entity.dart';

part 'task_by_asset_response_model.g.dart';

@JsonSerializable()
class TaskByAssetResponseModel {
  @JsonKey(name: 'data_task_by_asset_response')
  final List<TaskByAssetDataModel>? dataTaskByAssetResponse;

  const TaskByAssetResponseModel({
    this.dataTaskByAssetResponse,
  });

  factory TaskByAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByAssetResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByAssetResponseModelToJson(this);

  TaskByAssetResponseEntity toEntity() {
    return TaskByAssetResponseEntity(
      dataTaskByAssetResponse:
          dataTaskByAssetResponse?.map((item) => item.toEntity()).toList(),
    );
  }
}
