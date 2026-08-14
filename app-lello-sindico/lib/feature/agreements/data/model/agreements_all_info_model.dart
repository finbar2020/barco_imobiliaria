import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreement_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_rules_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_all_info.dart';

part 'agreements_all_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsAllInfoModel {
  List<AgreementModel> agreements;
  AgreementsRulesModel rule;

  AgreementsAllInfoModel({
    required this.agreements,
    required this.rule,
  });

  factory AgreementsAllInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsAllInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsAllInfoModelToJson(this);

  static AgreementsAllInfoModel? fromEntity(AgreementsAllInfo? entity) =>
      entity == null
          ? null
          : AgreementsAllInfoModel(
              agreements: entity.agreements
                  .map((e) => AgreementModel.fromEntity(e)!)
                  .toList(),
              rule: AgreementsRulesModel.fromEntity(entity.rule)!,
            );

  AgreementsAllInfo toEntity() => AgreementsAllInfo(
        agreements: this.agreements.map((e) => e.toEntity()).toList(),
        rule: this.rule.toEntity(),
      );
}
