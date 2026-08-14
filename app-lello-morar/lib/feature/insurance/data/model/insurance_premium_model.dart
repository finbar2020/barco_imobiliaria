import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_value_model.dart';

part 'insurance_premium_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsurancePremiumModel {
  double custo;
  List<InsurancePremiumValueModel> valores;

  InsurancePremiumModel({
    required this.custo,
    required this.valores,
  });

  factory InsurancePremiumModel.fromJson(Map<String, dynamic> json) =>
      _$InsurancePremiumModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsurancePremiumModelToJson(this);

  factory InsurancePremiumModel.clone(InsurancePremiumModel premium) =>
      InsurancePremiumModel(
        custo: premium.custo,
        valores: premium.valores,
      );
}
