import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';

part 'agreements_rules_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsRulesModel {
  int installmentQtd;
  List<int> days;
  // List<String> paymentMethod;

  AgreementsRulesModel({
    required this.installmentQtd,
    required this.days,
    // required this.paymentMethod,
  });

  factory AgreementsRulesModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsRulesModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsRulesModelToJson(this);

  static AgreementsRulesModel? fromEntity(AgreementsRules? entity) =>
      entity == null
          ? null
          : (AgreementsRulesModel(
              installmentQtd: entity.installmentQtd,
              days: entity.days,
              // paymentMethod: entity.paymentMethod,
            ));
  AgreementsRules toEntity() => AgreementsRules(
        installmentQtd: this.installmentQtd,
        days: this.days,
        // paymentMethod: this.paymentMethod,
      );
}
