import 'package:json_annotation/json_annotation.dart';

part 'task_by_asset_request_model.g.dart';

@JsonSerializable()
class TaskByAssetFiltersModel {
  @JsonKey(name: 'responsibleIds')
  final List<String>? responsibleIds;

  @JsonKey(name: 'assetIds')
  final List<String>? assetIds;

  @JsonKey(name: 'localIds')
  final List<String>? localIds;

  @JsonKey(name: 'typeTask')
  final List<String>? typeTask;

  @JsonKey(name: 'status')
  final List<String>? status;

  @JsonKey(name: 'dayCurrent')
  final String? dayCurrent;

  @JsonKey(name: 'localGroupIds')
  final List<String>? localGroupIds;

  @JsonKey(name: 'procedureIds')
  final List<String>? procedureIds;

  @JsonKey(name: 'assetGroupIds')
  final List<String>? assetGroupIds;

  @JsonKey(name: 'sectorIds')
  final List<String>? sectorIds;

  const TaskByAssetFiltersModel({
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
    this.dayCurrent,
    this.localGroupIds,
    this.procedureIds,
    this.assetGroupIds,
    this.sectorIds,
  });

  factory TaskByAssetFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByAssetFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByAssetFiltersModelToJson(this);
}

@JsonSerializable()
class TaskByAssetRequestModel {
  @JsonKey(name: 'dtStart')
  final String dtStart;

  @JsonKey(name: 'untilDate')
  final String untilDate;

  @JsonKey(name: 'filters')
  final TaskByAssetFiltersModel? filters;

  const TaskByAssetRequestModel({
    required this.dtStart,
    required this.untilDate,
    this.filters,
  });

  factory TaskByAssetRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByAssetRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByAssetRequestModelToJson(this);
}
