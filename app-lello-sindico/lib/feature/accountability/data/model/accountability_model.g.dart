// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityModel _$AccountabilityModelFromJson(Map<String, dynamic> json) =>
    AccountabilityModel(
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : AccountMonthlyFinanceModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      summary: (json['summary'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : AccountMonthlySummaryModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => AccountabilityRecommendationsModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      groupedEntries: (json['grouped_entries'] as List<dynamic>?)
              ?.map((e) => AccountabilityGroupedModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..period = json['period'] == null
          ? null
          : DateTime.parse(json['period'] as String)
      ..condominiumId = json['condominium_id'] as String?
      ..initialBalance = (json['initial_balance'] as num?)?.toDouble()
      ..totalIncome = (json['total_income'] as num?)?.toDouble()
      ..totalExpenses = (json['total_expenses'] as num?)?.toDouble()
      ..balance = (json['balance'] as num?)?.toDouble();

Map<String, dynamic> _$AccountabilityModelToJson(
        AccountabilityModel instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'summary': instance.summary,
      'period': instance.period?.toIso8601String(),
      'condominium_id': instance.condominiumId,
      'initial_balance': instance.initialBalance,
      'total_income': instance.totalIncome,
      'total_expenses': instance.totalExpenses,
      'balance': instance.balance,
      'grouped_entries': instance.groupedEntries,
      'recommendations': instance.recommendations,
    };
