import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';

part 'condominium_balance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumBalanceModel {
  String? id;
  double? balance;
  DateTime? date;
  double? previousBalance;
  double? forecast;
  double? income;
  double? expenses;
  String? reference;
  DateTime? lastUpdatedAt;

  CondominiumBalanceModel();

  factory CondominiumBalanceModel.fromJson(dynamic json) =>
      _$CondominiumBalanceModelFromJson(json);

  dynamic toJson() => _$CondominiumBalanceModelToJson(this);

  static CondominiumBalanceModel? fromEntity(CondominiumBalance? entity) =>
      entity == null
          ? null
          : (CondominiumBalanceModel()
            ..id = entity.id
            ..balance = entity.balance
            ..previousBalance = entity.previousBalance
            ..forecast = entity.forecast
            ..income = entity.income
            ..expenses = entity.expenses
            ..date = entity.date
            ..reference = entity.reference
            ..lastUpdatedAt = entity.lastUpdatedAt);

  CondominiumBalance toEntity() => CondominiumBalance()
    ..id = this.id
    ..balance = this.balance
    ..previousBalance = this.previousBalance
    ..forecast = this.forecast
    ..income = this.income
    ..expenses = this.expenses
    ..date = this.date
    ..reference = this.reference
    ..lastUpdatedAt = this.lastUpdatedAt;
}
