// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumBalanceModel _$CondominiumBalanceModelFromJson(
        Map<String, dynamic> json) =>
    CondominiumBalanceModel()
      ..id = json['id'] as String?
      ..balance = (json['balance'] as num?)?.toDouble()
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..previousBalance = (json['previous_balance'] as num?)?.toDouble()
      ..forecast = (json['forecast'] as num?)?.toDouble()
      ..income = (json['income'] as num?)?.toDouble()
      ..expenses = (json['expenses'] as num?)?.toDouble()
      ..reference = json['reference'] as String?
      ..lastUpdatedAt = json['last_updated_at'] == null
          ? null
          : DateTime.parse(json['last_updated_at'] as String);

Map<String, dynamic> _$CondominiumBalanceModelToJson(
        CondominiumBalanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'balance': instance.balance,
      'date': instance.date?.toIso8601String(),
      'previous_balance': instance.previousBalance,
      'forecast': instance.forecast,
      'income': instance.income,
      'expenses': instance.expenses,
      'reference': instance.reference,
      'last_updated_at': instance.lastUpdatedAt?.toIso8601String(),
    };
