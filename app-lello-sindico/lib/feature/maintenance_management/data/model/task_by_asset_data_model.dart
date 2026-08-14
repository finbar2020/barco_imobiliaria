import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/task_by_asset_entity.dart';

part 'task_by_asset_data_model.g.dart';

@JsonSerializable()
class TaskByAssetDataModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'done')
  final int? done;

  @JsonKey(name: 'draft')
  final int? draft;

  @JsonKey(name: 'not_started')
  final int? notStarted;

  @JsonKey(name: 'total')
  final int? total;

  const TaskByAssetDataModel({
    this.id,
    this.name,
    this.done,
    this.draft,
    this.notStarted,
    this.total,
  });

  factory TaskByAssetDataModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByAssetDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByAssetDataModelToJson(this);

  TaskByAssetDataEntity toEntity() {
    return TaskByAssetDataEntity(
      id: id != null ? int.tryParse(id!) : null,
      name: name,
      done: done,
      draft: draft,
      notStarted: notStarted,
      total: total,
    );
  }
}
