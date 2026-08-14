import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';

import 'condominium_balance_detail_debits_model.dart';
import 'condominium_balance_detail_summary_model.dart';

part 'condominium_balance_detail_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumBalanceDetailModel {
  double? previousBalance;
  double? balance;
  double? accountBalance;
  double? debit;
  double? credits;
  List<DebitsModel>? debits;
  List<SummaryModel>? summary;
  String? reference;
  DateTime? lastUpdatedAt;

  CondominiumBalanceDetailModel(
      {this.debits = const [], this.summary = const []});

  factory CondominiumBalanceDetailModel.fromJson(dynamic json) =>
      _$CondominiumBalanceDetailModelFromJson(json);
  dynamic toJson() => _$CondominiumBalanceDetailModelToJson(this);

  static CondominiumBalanceDetailModel? fromEntity(
          CondominiumBalanceDetail? entity) =>
      entity == null
          ? null
          : (CondominiumBalanceDetailModel()
            ..previousBalance = entity.previousBalance
            ..balance = entity.balance
            ..accountBalance = entity.accountBalance
            ..debit = entity.debit
            ..credits = entity.credits
            ..debits = entity.debits
                    ?.map((value) => DebitsModel.fromEntity(value)!)
                    .toList() ??
                []
            ..summary = entity.summary
                    ?.map((value) => SummaryModel.fromEntity(value)!)
                    .toList() ??
                []
            ..reference = entity.reference
            ..lastUpdatedAt = entity.lastUpdatedAt);

  CondominiumBalanceDetail toEntity() => CondominiumBalanceDetail()
    ..previousBalance = this.previousBalance
    ..balance = this.balance
    ..accountBalance = this.accountBalance
    ..debit = this.debit
    ..credits = this.credits
    ..debits = this.debits?.map((e) => e.toEntity()).toList() ?? []
    ..summary = this.summary?.map((e) => e.toEntity()).toList() ?? []
    ..reference = this.reference
    ..lastUpdatedAt = this.lastUpdatedAt;
}
