import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/data/model/account_monthly_finance_model.dart';
import 'package:lello/feature/accountability/data/model/account_monthly_summary_model.dart';
import 'package:lello/feature/accountability/data/model/accountability_recommendations_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_grouped_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';

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

  List<AccountabilityRecommendationsModel> recommendations;

  AccountabilityModel(
      {this.accounts = const [],
      this.summary = const [],
      this.recommendations = const [],
      this.groupedEntries = const []});

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
            ..groupedEntries = entity.groupedEntries
                .map((e) => AccountabilityGroupedModel.fromEntity(e))
                .toList()
            ..recommendations = entity.recommendations
                .map((e) => AccountabilityRecommendationsModel.fromEntity(e))
                .toList()
            ..initialBalance = entity.initialBalance
            ..totalIncome = entity.totalIncome
            ..period = entity.period
            ..condominiumId = entity.condominiumId
            ..totalExpenses = entity.totalExpenses
            ..balance = entity.balance);

  Accountability toEntity() => Accountability()
    ..accounts = accounts.map((e) => e?.toEntity()).toList()
    ..summary = summary.map((e) => e?.toEntity()).toList()
    ..groupedEntries = groupedEntries.map((e) => e.toEntity()).toList()
    ..recommendations = recommendations.map((e) => e.toEntity()).toList()
    ..initialBalance = initialBalance
    ..totalIncome = totalIncome
    ..totalExpenses = totalExpenses
    ..period = period
    ..condominiumId = condominiumId
    ..balance = balance;
}
