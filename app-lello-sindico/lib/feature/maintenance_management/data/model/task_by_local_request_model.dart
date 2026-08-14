import 'package:json_annotation/json_annotation.dart';

part 'task_by_local_request_model.g.dart';

@JsonSerializable()
class TaskByLocalFiltersModel {
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

  const TaskByLocalFiltersModel({
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

  factory TaskByLocalFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByLocalFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByLocalFiltersModelToJson(this);
}

@JsonSerializable()
class TaskByLocalRequestModel {
  @JsonKey(name: 'dtStart')
  final String dtStart;

  @JsonKey(name: 'untilDate')
  final String untilDate;

  @JsonKey(name: 'filters')
  final TaskByLocalFiltersModel? filters;

  const TaskByLocalRequestModel({
    required this.dtStart,
    required this.untilDate,
    this.filters,
  });

  factory TaskByLocalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByLocalRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByLocalRequestModelToJson(this);
}
