import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/accountability/data/model/acountability_grouped_account_entrie_model.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account.dart';

part 'acountability_grouped_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityGroupedAccountModel {
  int account;
  String description;
  List<AccountabilityGroupedAccountEntrieModel> entries;
  AccountabilityGroupedAccountModel(
      {required this.account,
      required this.description,
      required this.entries});

  factory AccountabilityGroupedAccountModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccountabilityGroupedAccountModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityGroupedAccountModelToJson(this);

  static AccountabilityGroupedAccountModel fromEntity(
          AccountabilityGroupedAccount entity) =>
      (AccountabilityGroupedAccountModel(
        account: entity.account,
        description: entity.description,
        entries: entity.entries
            .map((e) => AccountabilityGroupedAccountEntrieModel.fromEntity(e))
            .toList(),
      ));

  AccountabilityGroupedAccount toEntity() => AccountabilityGroupedAccount(
      account: this.account,
      description: this.description,
      entries: this.entries.map((e) => e.toEntity()).toList());
}
