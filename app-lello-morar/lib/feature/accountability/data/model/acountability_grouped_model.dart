import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/accountability/data/model/acountability_grouped_account_model.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';

part 'acountability_grouped_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityGroupedModel {
  String type;
  String description;
  int id;
  double debits;
  double credits;
  List<AccountabilityGroupedAccountModel> accounts;

  AccountabilityGroupedModel({
    required this.type,
    required this.description,
    required this.id,
    required this.debits,
    required this.credits,
    required this.accounts,
  });

  factory AccountabilityGroupedModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityGroupedModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountabilityGroupedModelToJson(this);

  static AccountabilityGroupedModel fromEntity(AccountabilityGrouped entity) =>
      (AccountabilityGroupedModel(
        type: entity.type,
        description: entity.description,
        id: entity.id,
        debits: entity.debits,
        credits: entity.credits,
        accounts: entity.accounts
            .map((e) => AccountabilityGroupedAccountModel.fromEntity(e))
            .toList(),
      ));

  AccountabilityGrouped toEntity() => AccountabilityGrouped(
      type: this.type,
      description: this.description,
      id: this.id,
      debits: this.debits,
      credits: this.credits,
      accounts: this.accounts.map((e) => e.toEntity()).toList());
}
