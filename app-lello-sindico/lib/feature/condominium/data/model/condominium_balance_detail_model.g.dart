// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_balance_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumBalanceDetailModel _$CondominiumBalanceDetailModelFromJson(
        Map<String, dynamic> json) =>
    CondominiumBalanceDetailModel(
      debits: (json['debits'] as List<dynamic>?)
              ?.map((e) => DebitsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      summary: (json['summary'] as List<dynamic>?)
              ?.map((e) => SummaryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..previousBalance = (json['previous_balance'] as num?)?.toDouble()
      ..balance = (json['balance'] as num?)?.toDouble()
      ..accountBalance = (json['account_balance'] as num?)?.toDouble()
      ..debit = (json['debit'] as num?)?.toDouble()
      ..credits = (json['credits'] as num?)?.toDouble()
      ..reference = json['reference'] as String?
      ..lastUpdatedAt = json['last_updated_at'] == null
          ? null
          : DateTime.parse(json['last_updated_at'] as String);

Map<String, dynamic> _$CondominiumBalanceDetailModelToJson(
        CondominiumBalanceDetailModel instance) =>
    <String, dynamic>{
      'previous_balance': instance.previousBalance,
      'balance': instance.balance,
      'account_balance': instance.accountBalance,
      'debit': instance.debit,
      'credits': instance.credits,
      'debits': instance.debits,
      'summary': instance.summary,
      'reference': instance.reference,
      'last_updated_at': instance.lastUpdatedAt?.toIso8601String(),
    };
