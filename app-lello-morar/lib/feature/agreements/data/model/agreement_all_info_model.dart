import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/data/model/agreement_quota_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_rule_model.dart';
import 'package:morar/feature/agreements/data/model/agreements_model.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';

part 'agreement_all_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementAllInfoModel {
  final List<AgreementQuotaModel> quotes;
  final List<AgreementModel> agreements;
  final AgreementRuleModel rule;

  AgreementAllInfoModel({
    required this.quotes,
    required this.agreements,
    required this.rule,
  });

  factory AgreementAllInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementAllInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementAllInfoModelToJson(this);

  static AgreementAllInfoModel fromEntity(AgreementAllInfo entity) =>
      (AgreementAllInfoModel(
        quotes: entity.quotes
            .map((e) => AgreementQuotaModel.fromEntity(e))
            .toList(),
        agreements:
            entity.agreements.map((e) => AgreementModel.fromEntity(e)).toList(),
        rule: AgreementRuleModel.fromEntity(entity.rule),
      ));

  AgreementAllInfo toEntity() => AgreementAllInfo(
        quotes: this.quotes.map((e) => e.toEntity()).toList(),
        agreements: this.agreements.map((e) => e.toEntity()).toList(),
        rule: this.rule.toEntity(),
      );
}
