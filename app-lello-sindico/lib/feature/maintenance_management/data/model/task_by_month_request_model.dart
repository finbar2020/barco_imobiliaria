import 'package:json_annotation/json_annotation.dart';

part 'task_by_month_request_model.g.dart';

@JsonSerializable()
class TaskByMonthFiltersModel {
  @JsonKey(name: 'typeTask')
  final List<String> typeTask;
  @JsonKey(name: 'status')
  final List<String> status;
  @JsonKey(name: 'responsibleIds')
  final List<String> responsibleIds;
  @JsonKey(name: 'localIds')
  final List<String> localIds;
  @JsonKey(name: 'assetIds')
  final List<String> assetIds;

  const TaskByMonthFiltersModel({
    required this.typeTask,
    required this.status,
    required this.responsibleIds,
    required this.localIds,
    required this.assetIds,
  });

  factory TaskByMonthFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByMonthFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByMonthFiltersModelToJson(this);
}

@JsonSerializable()
class TaskByMonthRequestModel {
  @JsonKey(name: 'dtStart')
  final String dtStart;
  @JsonKey(name: 'untilDate')
  final String untilDate;
  @JsonKey(name: 'filters')
  final TaskByMonthFiltersModel filters;

  const TaskByMonthRequestModel({
    required this.dtStart,
    required this.untilDate,
    required this.filters,
  });

  factory TaskByMonthRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByMonthRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByMonthRequestModelToJson(this);
}