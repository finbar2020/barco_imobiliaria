import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/accountability/data/model/account_monthly_finance_model.dart';
import 'package:morar/feature/accountability/data/model/account_monthly_summary_model.dart';
import 'package:morar/feature/accountability/data/model/acountability_grouped_model.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';

part 'accountability_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityModel {
  List<AccountMonthlyFinanceModel?> accounts;
  List<AccountMonthlySummaryModel?> summary;
  DateTime? period;
  String? condominiumId;
  double? initialBalance;
  double? totalIncome;
  double? totalExpenses;
  double? balance;
  List<AccountabilityGroupedModel> groupedEntries;

  AccountabilityModel({
    this.accounts = const [],
    this.summary = const [],
    this.period,
    this.condominiumId,
    this.initialBalance,
    this.totalIncome,
    this.totalExpenses,
    this.balance,
    this.groupedEntries = const [],
  });

  factory AccountabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountabilityModelToJson(this);

  static AccountabilityModel? fromEntity(Accountability? entity) =>
      entity == null
          ? null
          : (AccountabilityModel()
            ..accounts = entity.accounts
                .map((e) => AccountMonthlyFinanceModel.fromEntity(e))
                .toList()
            ..summary = entity.summary
                .map((e) => AccountMonthlySummaryModel.fromEntity(e))
                .toList()
            ..initialBalance = entity.initialBalance
            ..totalIncome = entity.totalIncome
            ..period = entity.period
            ..condominiumId = entity.condominiumId
            ..totalExpenses = entity.totalExpenses
            ..balance = entity.balance
            ..groupedEntries = entity.groupedEntries
                .map((e) => AccountabilityGroupedModel.fromEntity(e))
                .toList());

  Accountability toEntity() => Accountability()
    ..accounts = this.accounts.map((e) => e?.toEntity()).toList()
    ..summary = this.summary.map((e) => e?.toEntity()).toList()
    ..initialBalance = this.initialBalance
    ..totalIncome = this.totalIncome
    ..totalExpenses = this.totalExpenses
    ..period = this.period
    ..condominiumId = this.condominiumId
    ..balance = this.balance
    ..groupedEntries = this.groupedEntries.map((e) => e.toEntity()).toList();
}
