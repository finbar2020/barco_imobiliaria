import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/data/model/agreement_payment_method_model.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_rule.dart';

part 'agreement_rule_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementRuleModel {
  final int installmentQtd;
  final List<int> days;
  final List<AgreementPaymentMethodModel> paymentMethod;

  AgreementRuleModel({
    required this.installmentQtd,
    required this.days,
    required this.paymentMethod,
  });

  factory AgreementRuleModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementRuleModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementRuleModelToJson(this);

  static AgreementRuleModel fromEntity(AgreementRule entity) =>
      (AgreementRuleModel(
        installmentQtd: entity.installmentQtd,
        days: entity.days,
        paymentMethod: entity.paymentMethod
            .map((e) => AgreementPaymentMethodModel.fromEntity(e))
            .toList(),
      ));

  AgreementRule toEntity() => AgreementRule(
        installmentQtd: this.installmentQtd,
        days: this.days,
        paymentMethod: this.paymentMethod.map((e) => e.toEntity()).toList(),
      );
}
