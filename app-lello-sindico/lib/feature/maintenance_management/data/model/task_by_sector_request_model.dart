import 'package:json_annotation/json_annotation.dart';

part 'task_by_sector_request_model.g.dart';

@JsonSerializable()
class TaskBySectorFiltersModel {
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

  const TaskBySectorFiltersModel({
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

  factory TaskBySectorFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$TaskBySectorFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskBySectorFiltersModelToJson(this);
}

@JsonSerializable()
class TaskBySectorRequestModel {
  @JsonKey(name: 'dtStart')
  final String dtStart;

  @JsonKey(name: 'untilDate')
  final String untilDate;

  @JsonKey(name: 'filters')
  final TaskBySectorFiltersModel? filters;

  const TaskBySectorRequestModel({
    required this.dtStart,
    required this.untilDate,
    this.filters,
  });

  factory TaskBySectorRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TaskBySectorRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskBySectorRequestModelToJson(this);
}
