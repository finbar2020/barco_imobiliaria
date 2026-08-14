import 'package:json_annotation/json_annotation.dart';
import 'formulary_data_point_model.dart';

part 'formulary_by_month_data_model.g.dart';

@JsonSerializable()
class FormularyByMonthDataModel {
  final String name;
  final List<FormularyDataPointModel> data;

  const FormularyByMonthDataModel({
    required this.name,
    required this.data,
  });

  factory FormularyByMonthDataModel.fromJson(Map<String, dynamic> json) =>
      _$FormularyByMonthDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormularyByMonthDataModelToJson(this);
}
