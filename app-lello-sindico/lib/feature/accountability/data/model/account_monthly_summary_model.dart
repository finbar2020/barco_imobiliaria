import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/domain/entity/account_monthly_summary.dart';

part 'account_monthly_summary_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountMonthlySummaryModel {
  String? name;
  double? debits;
  double? credits;

  AccountMonthlySummaryModel();

  factory AccountMonthlySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AccountMonthlySummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountMonthlySummaryModelToJson(this);

  static AccountMonthlySummaryModel? fromEntity(
          AccountMonthlySummary? entity) =>
      entity == null
          ? null
          : (AccountMonthlySummaryModel()
            ..name = entity.name
            ..debits = entity.debits
            ..credits = entity.credits);

  AccountMonthlySummary toEntity() => AccountMonthlySummary()
    ..name = this.name
    ..debits = this.debits
    ..credits = this.credits;
}
