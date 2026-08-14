import 'package:json_annotation/json_annotation.dart';
import 'task_by_month_data_point_model.dart';

part 'task_by_month_data_model.g.dart';

@JsonSerializable()
class TaskByMonthDataModel {
  final String name;
  final List<TaskByMonthDataPointModel> data;

  const TaskByMonthDataModel({
    required this.name,
    required this.data,
  });

  factory TaskByMonthDataModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByMonthDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByMonthDataModelToJson(this);
}