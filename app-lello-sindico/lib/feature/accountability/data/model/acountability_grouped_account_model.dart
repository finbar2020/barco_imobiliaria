import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/data/model/acountability_grouped_account_entrie_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account.dart';

part 'acountability_grouped_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityGroupedAccaountModel {
  int account;
  String description;
  List<AccountabilityGroupedAccaountEntrieModel> entries;
  AccountabilityGroupedAccaountModel(
      {required this.account,
      required this.description,
      required this.entries});

  factory AccountabilityGroupedAccaountModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccountabilityGroupedAccaountModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityGroupedAccaountModelToJson(this);

  static AccountabilityGroupedAccaountModel fromEntity(
          AccountabilityGroupedAccount entity) =>
      (AccountabilityGroupedAccaountModel(
        account: entity.account,
        description: entity.description,
        entries: entity.entries
            .map((e) => AccountabilityGroupedAccaountEntrieModel.fromEntity(e))
            .toList(),
      ));

  AccountabilityGroupedAccount toEntity() => AccountabilityGroupedAccount(
      account: this.account,
      description: this.description,
      entries: this.entries.map((e) => e.toEntity()).toList());
}
