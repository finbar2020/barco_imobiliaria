import 'package:json_annotation/json_annotation.dart';
import 'task_by_month_data_model.dart';

part 'task_by_month_response_model.g.dart';

@JsonSerializable()
class TaskByMonthResponseModel {
  @JsonKey(name: 'formularyByMonthDTO')
  final List<TaskByMonthDataModel> formularyByMonthDto;
  final int totalConcluidos;
  final int totalNaoConcluidos;
  final int totalGeral;

  const TaskByMonthResponseModel({
    required this.formularyByMonthDto,
    required this.totalConcluidos,
    required this.totalNaoConcluidos,
    required this.totalGeral,
  });

  factory TaskByMonthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TaskByMonthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskByMonthResponseModelToJson(this);
}