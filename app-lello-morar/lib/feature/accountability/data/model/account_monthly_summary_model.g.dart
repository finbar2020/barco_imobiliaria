// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_monthly_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountMonthlySummaryModel _$AccountMonthlySummaryModelFromJson(
        Map<String, dynamic> json) =>
    AccountMonthlySummaryModel()
      ..name = json['name'] as String?
      ..debits = (json['debits'] as num?)?.toDouble()
      ..credits = (json['credits'] as num?)?.toDouble();

Map<String, dynamic> _$AccountMonthlySummaryModelToJson(
        AccountMonthlySummaryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'debits': instance.debits,
      'credits': instance.credits,
    };
