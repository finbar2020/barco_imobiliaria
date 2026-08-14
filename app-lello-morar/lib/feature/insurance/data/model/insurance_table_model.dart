import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_model.dart';

part 'insurance_table_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsuranceTableModel {
  String telefone;
  String assistencia;
  List<InsurancePremiumModel> premio;
  Map<String, String> titulos;

  InsuranceTableModel({
    required this.telefone,
    required this.assistencia,
    required this.premio,
    required this.titulos,
  });

  factory InsuranceTableModel.fromJson(Map<String, dynamic> json) =>
      _$InsuranceTableModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsuranceTableModelToJson(this);

  factory InsuranceTableModel.clone(InsuranceTableModel table) =>
      InsuranceTableModel(
        telefone: table.telefone,
        assistencia: table.assistencia,
        premio:
            table.premio.map((e) => InsurancePremiumModel.clone(e)).toList(),
        titulos: Map.from(table.titulos),
      );
}
