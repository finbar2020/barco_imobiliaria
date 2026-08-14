import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/account/data/model/account_model.dart';
import 'package:lello/feature/accountability/domain/entity/account_monthly_finance.dart';

part 'account_monthly_finance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountMonthlyFinanceModel {
  AccountModel? account;
  double? income;
  double? expenses;
  double? initialBalance;
  double? balance;

  AccountMonthlyFinanceModel();

  factory AccountMonthlyFinanceModel.fromJson(Map<String, dynamic> json) =>
      _$AccountMonthlyFinanceModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountMonthlyFinanceModelToJson(this);

  static AccountMonthlyFinanceModel? fromEntity(
          AccountMonthlyFinance? entity) =>
      entity == null
          ? null
          : (AccountMonthlyFinanceModel()
            ..account = AccountModel.fromEntity(entity.account)
            ..income = entity.income
            ..expenses = entity.expenses
            ..initialBalance = entity.initialBalance
            ..balance = entity.balance);

  AccountMonthlyFinance toEntity() => AccountMonthlyFinance()
    ..account = this.account?.toEntity()
    ..income = this.income
    ..initialBalance = this.initialBalance
    ..balance = this.balance
    ..expenses = this.expenses;
}
