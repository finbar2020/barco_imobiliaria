import 'package:json_annotation/json_annotation.dart';

part 'task_by_month_data_point_model.g.dart';

@JsonSerializable()
class TaskByMonthDataPointModel {
  final String key;
  @JsonKey(fromJson: _valueFromJson)
  final int value;

  const TaskByMonthDataPointModel({
    required this.key,
    required this.value,
  });

  static int _valueFromJson(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is int) {
      return value;
    }
    return 0;
  }

  factory TaskByMonthDataPointModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByMonthDataPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByMonthDataPointModelToJson(this);
}