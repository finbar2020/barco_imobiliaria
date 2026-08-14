import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_rule.dart';

part 'insurance_rule_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InsuranceRuleModel {
  String? id;
  String? name;
  String? description;
  double? cost;
  String? linkTerms;

  InsuranceRuleModel({
    this.name,
    this.cost,
  });

  factory InsuranceRuleModel.fromJson(Map<String, dynamic> json) =>
      _$InsuranceRuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsuranceRuleModelToJson(this);

  static InsuranceRuleModel? fromEntity(InsuranceRule? entity) => entity == null
      ? null
      : (InsuranceRuleModel()
        ..id = entity.id
        ..name = entity.name
        ..description = entity.description
        ..cost = entity.cost
        ..linkTerms = entity.linkTerms);

  InsuranceRule toEntity() => InsuranceRule()
    ..id = this.id
    ..name = this.name
    ..description = this.description
    ..cost = this.cost
    ..linkTerms = this.linkTerms;
}
