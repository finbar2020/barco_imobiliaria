// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_balance_detail_debits_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitsModel _$DebitsModelFromJson(Map<String, dynamic> json) => DebitsModel()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..period =
      json['period'] == null ? null : DateTime.parse(json['period'] as String)
  ..type = json['type'] as String?
  ..previousBalance = (json['previous_balance'] as num?)?.toDouble()
  ..balance = (json['balance'] as num?)?.toDouble()
  ..accountBalance = (json['account_balance'] as num?)?.toDouble()
  ..debit = (json['debit'] as num?)?.toDouble()
  ..credits = (json['credits'] as num?)?.toDouble();

Map<String, dynamic> _$DebitsModelToJson(DebitsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'period': instance.period?.toIso8601String(),
      'type': instance.type,
      'previous_balance': instance.previousBalance,
      'balance': instance.balance,
      'account_balance': instance.accountBalance,
      'debit': instance.debit,
      'credits': instance.credits,
    };
