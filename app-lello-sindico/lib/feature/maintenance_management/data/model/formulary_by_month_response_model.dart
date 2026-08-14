import 'package:json_annotation/json_annotation.dart';
import 'formulary_by_month_data_model.dart';

part 'formulary_by_month_response_model.g.dart';

@JsonSerializable()
class FormularyByMonthResponseModel {
  @JsonKey(name: 'formularyByMonthDTO')
  final List<FormularyByMonthDataModel> formularyByMonthDto;
  final int totalConcluidos;
  final int totalNaoConcluidos;
  final int totalGeral;

  const FormularyByMonthResponseModel({
    required this.formularyByMonthDto,
    required this.totalConcluidos,
    required this.totalNaoConcluidos,
    required this.totalGeral,
  });

  factory FormularyByMonthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FormularyByMonthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormularyByMonthResponseModelToJson(this);
}
