// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_monthly_finance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountMonthlyFinanceModel _$AccountMonthlyFinanceModelFromJson(
        Map<String, dynamic> json) =>
    AccountMonthlyFinanceModel()
      ..account = json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>)
      ..income = (json['income'] as num?)?.toDouble()
      ..expenses = (json['expenses'] as num?)?.toDouble()
      ..initialBalance = (json['initial_balance'] as num?)?.toDouble()
      ..balance = (json['balance'] as num?)?.toDouble();

Map<String, dynamic> _$AccountMonthlyFinanceModelToJson(
        AccountMonthlyFinanceModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'income': instance.income,
      'expenses': instance.expenses,
      'initial_balance': instance.initialBalance,
      'balance': instance.balance,
    };
