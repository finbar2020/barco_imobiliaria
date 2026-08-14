import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreement_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_proposals.dart';

part 'agreements_proposals_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementsProposalsModel {
  List<AgreementModel> agreements;

  AgreementsProposalsModel({
    required this.agreements,
  });

  factory AgreementsProposalsModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementsProposalsModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementsProposalsModelToJson(this);

  static AgreementsProposalsModel? fromEntity(AgreementsProposals? entity) =>
      entity == null
          ? null
          : (AgreementsProposalsModel(
              agreements: entity.agreements
                  .map((agreement) => AgreementModel.fromEntity(agreement)!)
                  .toList()));
  AgreementsProposals toEntity() => AgreementsProposals(
        agreements:
            this.agreements.map((agreement) => agreement.toEntity()).toList(),
      );
}
